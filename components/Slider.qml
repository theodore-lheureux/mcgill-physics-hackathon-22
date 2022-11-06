import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
	property double min: NaN
	property double max: NaN
	property double initial: NaN
	property double value: slider.value
	property string text: "<UNTITLED>"

	Label { text: parent.text; Layout.alignment: Qt.AlignCenter }
	Slider {
		id: slider

		from: parent.min
		to: parent.max
		value: parent.initial

		Layout.alignment: Qt.AlignCenter		
	}
	Label { text: Math.round(slider.value, 2); Layout.alignment: Qt.AlignCenter }
}