import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/events_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/validators.dart';
import '../../ui/custom_snackbars.dart';

class EventCreationView extends StatelessWidget {
  const EventCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 45,
                )),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text('CREAR EVENTO',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
            child: LoginContainer(
              child: _FormsColumn(),
            ),
          )),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();

  _FormsColumn();

  @override
  Widget build(BuildContext context) {
    String? id = AuthService().currentUser?.uid ?? "";
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextForm(
            hintText: 'Nombre del evento',
            controller: _name,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Lugar',
            controller: _address,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Ciudad',
            controller: _city,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'País',
            controller: _country,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: _description,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Link de la imagen',
            controller: _image,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          DateTimePicker(),
          // const CustomTextForm(
          //   hintText: 'Fecha y hora',
          //   type: TextInputType.datetime,
          //   //TODO AÑADIR VALIDADOR
          // ),
          const CategoryDropdown(),
          SubmitButton(
            text: 'CONTINUAR',
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ]),
                );

                await EventsService().saveEvent(new Event(
                    address: _address.text,
                    city: _city.text,
                    country: _country.text,
                    description: _description.text,
                    finished: false,
                    image: _image.text,
                    name: _name.text,
                    startDate: DateTime.now(),
                    tags: ["football"],
                    users: [id],
                    id: Uuid().v1()));

                // await usersService.getUsers();

                await Future.delayed(Duration(seconds: 1));
                Navigator.pushReplacementNamed(context, 'main');
              } else {
                CustomSnackbars.showCustomSnackbar(
                  context,
                  const Text('Rellene los campos'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class DateTimePicker extends StatefulWidget {
  @override
  _DateTimePicker createState() => _DateTimePicker();
}

class _DateTimePicker extends State<DateTimePicker> {
  var _currentSelectedDate;
  var _currentSelectedTime;

  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
  }

  Future<DateTime?> getDatePickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
  }

  void callTimePicker() async {
    var selectedTime = await getTimePickerWidget();
    setState(() {
      _currentSelectedTime = selectedTime;
    });
  }

  Future<TimeOfDay?> getTimePickerWidget() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic _displayedSelectedDate = _currentSelectedDate ?? " ";
    dynamic _displayedSelectedTime = _currentSelectedTime ?? " ";
    dynamic _displayedCompleteDateTime = _displayedSelectedDate
            .toString()
            .split(" ")
            .first +
        " " +
        _displayedSelectedTime.toString().split("(").last.replaceAll(")", "");
    // _displayedSelectedDate + DateTime.parse(_displayedSelectedTime);
    return Column(
      children: [
        CustomButton(
          onTap: callDatePicker,
          text: 'Seleccione la fecha',
        ),
        CustomButton(
          onTap: callTimePicker,
          text: 'Seleccione la hora',
        ),
        CustomTextForm(
          hintText: "$_displayedCompleteDateTime",
          enabled: false,
        )
      ],
    );
  }
}
