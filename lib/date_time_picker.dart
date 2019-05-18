// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _InputDropdown extends StatelessWidget {
	const _InputDropdown({
		Key key,
		this.child,
		this.labelText,
		this.valueText,
		this.valueStyle,
		this.onPressed,
	}) : super(key: key);

	final String labelText;
	final String valueText;
	final TextStyle valueStyle;
	final VoidCallback onPressed;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: onPressed,
			child: InputDecorator(
				decoration: InputDecoration(
					labelText: labelText,
					labelStyle: TextStyle(color: Colors.white),
					border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
					enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),

				),
				baseStyle: valueStyle,
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						Text(valueText, style: valueStyle),
						Icon(Icons.arrow_drop_down, color: Colors.white70),
					],
				),
			),
		);
	}
}

class _DateTimePicker extends StatelessWidget {
	const _DateTimePicker({
		Key key,
		this.selectedDate,
		this.selectedTime,
		this.selectDate,
		this.selectTime,
	}) : super(key: key);

	final DateTime selectedDate;
	final TimeOfDay selectedTime;
	final ValueChanged<DateTime> selectDate;
	final ValueChanged<TimeOfDay> selectTime;

	Future<void> _selectDate(BuildContext context) async {
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: selectedDate,
			firstDate: DateTime(2019, 5, 18),
			lastDate: DateTime(2101),
		);
		if (picked != null && picked != selectedDate)
			selectDate(picked);
	}

	Future<void> _selectTime(BuildContext context) async {
		final TimeOfDay picked = await showTimePicker(
			context: context,
			initialTime: TimeOfDay.now(),
		);
		if (picked != null && picked != selectedTime)
			selectTime(picked);
	}

	@override
	Widget build(BuildContext context) {
		final TextStyle valueStyle = Theme.of(context).textTheme.body1.copyWith(color: Colors.white);
		return Row(
			crossAxisAlignment: CrossAxisAlignment.end,
			children: <Widget>[
				Expanded(
					flex: 4,
					child: _InputDropdown(
						valueText: DateFormat.yMMMd().format(selectedDate),
						valueStyle: valueStyle,
						onPressed: () { _selectDate(context); },
					),
				),
				const SizedBox(width: 12.0),
				Expanded(
					flex: 3,
					child: _InputDropdown(
						valueText: selectedTime.format(context),
						valueStyle: valueStyle,
						onPressed: () { _selectTime(context); },
					),
				),
			],
		);
	}
}

class DateAndTimePickerDemo extends StatefulWidget {

	@override
	_DateAndTimePickerDemoState createState() => _DateAndTimePickerDemoState();
}

class _DateAndTimePickerDemoState extends State<DateAndTimePickerDemo> {
	DateTime _fromDate = DateTime.now();
	TimeOfDay _fromTime = TimeOfDay.now();

	@override
	Widget build(BuildContext context) {
		return DropdownButtonHideUnderline(
				child: SafeArea(
					top: false,
					bottom: false,
					child: ListView(
						primary: false,
						shrinkWrap: true,
						children: <Widget>[
							_DateTimePicker(
								selectedDate: _fromDate,
								selectedTime: _fromTime,
								selectDate: (DateTime date) {
									setState(() {
										_fromDate = date;
									});
								},
								selectTime: (TimeOfDay time) {
									setState(() {
										_fromTime = time;
									});
								},
							),
						],
					),
				),
		);
	}
}
