import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metro_app/ViewModels/admin_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../Models/employee_model.dart';
import 'dart:js' as js;

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _formkey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final FocusNode pwdNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<AdminViewModel>(
        builder: (context, viewmodel, child) {
          if (viewmodel.isSignedIn) {
            return signedInView(viewmodel);
          } else {
            return signInView(viewmodel);
          }
        },
      ),
    );
  }

  Widget signedInView(AdminViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
              //add employee
              Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                      ? 400
                      : 600,
                  child: Form(
                    //will need key for validation
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Employee',
                          style: GoogleFonts.raleway(
                            textStyle: const TextStyle(
                              color: Colors.blue,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ResponsiveRowColumn(
                          layout: ResponsiveWrapper.of(context)
                                  .isSmallerThan(DESKTOP)
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          rowCrossAxisAlignment: CrossAxisAlignment.center,
                          rowMainAxisAlignment: MainAxisAlignment.center,
                          columnCrossAxisAlignment: CrossAxisAlignment.center,
                          columnMainAxisAlignment: MainAxisAlignment.center,
                          rowPadding: const EdgeInsets.all(15),
                          columnPadding: const EdgeInsets.all(15),
                          rowSpacing: 15,
                          columnSpacing: 15,
                          children: [
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: viewModel.fNameController,
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input a value';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'First Name'),
                              ),
                            ),
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: viewModel.lNameController,
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input a value';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Last Name'),
                              ),
                            ),
                          ],
                        ),
                        ResponsiveRowColumn(
                          layout: ResponsiveWrapper.of(context)
                                  .isSmallerThan(DESKTOP)
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          rowCrossAxisAlignment: CrossAxisAlignment.center,
                          rowMainAxisAlignment: MainAxisAlignment.center,
                          columnCrossAxisAlignment: CrossAxisAlignment.center,
                          columnMainAxisAlignment: MainAxisAlignment.center,
                          rowPadding: const EdgeInsets.all(15),
                          columnPadding: const EdgeInsets.all(15),
                          rowSpacing: 15,
                          columnSpacing: 15,
                          children: [
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: viewModel.phoneController,
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input a value';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Must be numeric';
                                  }
                                  if (value.length != 10) {
                                    return 'Must be 10 digits. No dashes or spaces';
                                  }
                                  return null;
                                },
                                decoration:
                                    const InputDecoration(labelText: 'Phone #'),
                              ),
                            ),
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    labelText: "Department"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a value';
                                  }
                                  return null;
                                },
                                items: viewModel.departmentItems
                                    .map(
                                      (e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(e),
                                          ))),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    viewModel.setDepartment(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                final Employee employee = Employee(
                                    firstname: viewModel.fNameController.text,
                                    lastname: viewModel.lNameController.text,
                                    phone: viewModel.phoneController.text,
                                    department: viewModel.department,
                                    onCall: false);
                                await viewModel.createEmployee(
                                    context, employee);
                              }
                            },
                            child: const Text('Submit')),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'All Employees',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(color: Colors.blue)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
                child: TextField(
                  controller: viewModel.searchController,
                  decoration: const InputDecoration(hintText: 'Search'),
                  onChanged: (value) {
                    viewModel.getEmployeesByFilter(value);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ] +
            viewModel.getAllEmployeesAsWidget(context) +
            const [
              SizedBox(
                height: 30,
              )
            ],
      ),
    );
  }

  Widget signInView(AdminViewModel viewModel) {
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 200,
          height: 175,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const Text("Admin Sign In"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: viewModel.obscurePwd,
                  focusNode: pwdNode,
                  onChanged: (_) async {
                    fixEdgePasswordRevealButton(pwdNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(viewModel.obscurePwd
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          viewModel.obscurePwd = !viewModel.obscurePwd;
                        });
                      },
                    ),
                    
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input a value';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      viewModel.signUserIn(context, _passwordController.text);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableView<T> extends StatefulWidget {
  final String title;
  final int? duration;
  final List<Widget> children;
  final T value;
  final T comparedValue;
  final Function() onTap;

  const ExpandableView({
    Key? key,
    required this.title,
    this.duration,
    required this.value,
    required this.comparedValue,
    required this.onTap,
    required this.children,
  }) : super(key: key);

  @override
  State<ExpandableView> createState() => _ExpandableViewState();
}

class _ExpandableViewState extends State<ExpandableView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: widget.duration ?? 700),
            height: widget.value == widget.comparedValue ? 150 : 0,
            curve: Curves.easeInOut,
            child: ClipRect(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void fixEdgePasswordRevealButton(FocusNode passwordFocusNode) {
  passwordFocusNode.unfocus();
  Future.microtask(() {
    passwordFocusNode.requestFocus();
    js.context.callMethod("fixPasswordCss", []);
  });
}
