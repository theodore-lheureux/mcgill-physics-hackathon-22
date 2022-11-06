import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Window
import QtQuick.Layouts
import QtCharts 
import QtMultimedia

import com.hackathon.base
import com.hackathon.position

import "./components" as Components

Rectangle {
	id: app

	property int spacing: 15

	anchors.fill: parent
	radius: 15
	color: "#121212"
	opacity: 0

	Base { id: base }
	Position { id: position }

	NumberAnimation {
		target: app
		properties: "opacity,scale"
		from: 0
		to: 1
		duration: 1000
		easing.type: Easing.InOutBack
		running: true
	}

	NumberAnimation {
		id: closeAnim

		target: app
		properties: "opacity,scale"
		from: 1
		to: 0
		duration: 1000
		easing.type: Easing.InOutBack

		onFinished: Qt.quit()
	}

	Timer {
		id: logicTimer
		interval: 16
		repeat: true

		property double angle: 0

		// variables
		property double m1: field_m1.value  
		property double m2: field_m2.value  
		property double r: field_r.value 
		property double speed: 1
		property double v: field_v.value
		property double v_ang: field_v_ang.value

		property double x3: 500
		property double y3: 500

		property double speedup
	

		onTriggered: {	
			let barycenter = base.barycenter(m1, m2, r)
			let lagrange_dist = base.lagrange_dist(m1, m2, r)
			let t = base.rotation_period(m1, m2, barycenter.x, barycenter.y) * (speed)

			// place 2 first astres
			let posM1 = position.pos_object(angle, barycenter.x, true)
			object1.x = posM1.x + simulation.width / 2 - object1.width / 2
			object1.y = posM1.y + simulation.height / 2 - object1.height / 2

			let posM2 = position.pos_object(angle, barycenter.y, false)
			object2.x = posM2.x + simulation.width / 2 - object2.width / 2
			object2.y = posM2.y + simulation.height / 2 - object2.height / 2
			
			// place Lagrange pts
			let pos_lagrange = position.pos_lagrange(lagrange_dist[0], lagrange_dist[1], lagrange_dist[2], posM2.x, posM2.y, barycenter.x, r, angle, m1, m2)
			lagrange_points.model = pos_lagrange

			// Place Object 3
			let posM3 = position.pos_object3(m1, m2, object1.x, object1.y, object2.x, object2.y, object3.x, object3.y, v, v_ang, t)

			object3.visible = true


			if (posM3) {
				object3.x = posM3.x
				object3.y = posM3.y
			} else {
				object3.visible = false
				prompt2.show("Collision detected. Click anywhere to replace object")
			}

			angle += 0.005 * field_speed.value
		}
	}
	
	Pane {
		id: menu

		property double w: layout.implicitWidth + app.spacing * 4
		property double h: heading.implicitHeight + layout.implicitHeight + app.spacing * 4
		
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: app.spacing
		clip: true
		z: 1
		
		background: Rectangle {
			color: menu.Material.backgroundColor
			radius: 15

			layer.enabled: menu.enabled && menu.Material.elevation > 0
			layer.effect: ElevationEffect {
				elevation: 10
			}
		}	

		Label {
			id: heading

			text: "Parameters"
			font.pointSize: 30
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: app.spacing
			anchors.leftMargin: 40
		}

		ColumnLayout {
			id: layout

			anchors.top: heading.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: app.spacing
			
			Components.Slider {
				id: field_speed
				text: "Simulation speed"
				min: 1
				max: 100
				initial: 1
				unit: "x (not actual time)"
			}

			Components.Slider {
				id: field_m1
				text: "Mass of 1st object"
				min: 50
				max: 300
				initial: 100
				unit: "kg"
			}

			Components.Slider {
				id: field_m2
				text: "Mass of 2nd object"
				min: 1
				max: 10
				initial: 1
				unit: "kg"
			}

			Components.Slider {
				id: field_r
				text: "Distance b/w masses"
				min: 0
				max: 500
				initial: 70
				unit: "km"
			}

			ToolSeparator { Layout.fillWidth: true; orientation: Qt.Horizontal }

			Components.Slider {
				id: field_v
				text: "Velocity of 3rd object"
				min: -1
				max: 1
				initial: 0
				unit: "m/s"
			}

			RowLayout {
				Label { 
					text: "Velocity angle"
					Layout.alignment: Qt.AlignCenter 
					Layout.preferredWidth: 200 // dumb hack
					clip: true 
				}
				Dial {
					id: field_v_ang

					from: 0
					to: 2 * Math.PI + (Math.PI)
					value: 0
					stepSize: 0.1
					snapMode: Dial.SnapAlways	
					wrap: true
				}
			}

			Label {
				Layout.fillWidth: true
				text: "Click on canvas to set object position"
				horizontalAlignment: Qt.AlignHCenter
				font.pointSize: 12
			}

			Row {
				RoundButton {
					Layout.alignment: Qt.AlignRight

					id: aboutBtn

					icon.source: "assets/about_icon.png"
					onClicked: aboutMenu.popup()

					Menu {
						id: aboutMenu

						Action {
							text: "About"
							icon.source: "assets/app_icon.png"
							onTriggered: base.about()
						}
						Action {
							text: "About Qt"
							icon.source: "assets/about_icon.png"
							onTriggered: base.aboutQt()
						}
					}
				}
			}
		}

		state: "closed"
		states: [
			State {
				name: "open"
				PropertyChanges {
					target: menu
					width: menu.w
					height: menu.h
					opacity: 1
				}
			},
			State {
				name: "closed"
				PropertyChanges {
					target: menu
					width: 0
					height: 0
					opacity: 0
				}
			}
		]

		transitions: Transition {
			NumberAnimation {
				properties: "width, height, opacity"
				duration: 500
				easing.type: Easing.InOutBack
			}
		}
	}

	Video {
		id: background

		property double parallaxStrength: 0.05

		x: (-flick.contentX - flick.width / 2) * parallaxStrength
		y: (-flick.contentY - flick.height / 2) * parallaxStrength
		z: 0
		scale: 1.1

		playbackRate: 1 + (field_speed.value / field_speed.max)

		width: parent.width
		height: parent.height
		anchors.margins: 5
		source: Qt.resolvedUrl("assets/video.mp4")
		opacity: 0.3
		fillMode: VideoOutput.PreserveAspectCrop
		loops: MediaPlayer.Infinite
	}

	Flickable {
		id: flick
		anchors.fill: parent

		contentWidth: parent.width * 2
		contentHeight: parent.height * 2
		contentX: parent.width / 2
		contentY: parent.height / 2
		
		MouseArea {
			id: flickarea

			anchors.fill: parent
			
			onWheel: (wheel) => {
				simulation.scale += wheel.angleDelta.y * 0.002
			}

			onClicked: (mouse) => {
				let coords = mapToItem(simulation, mouse.x - object3.width * 2, mouse.y - object3.height * 2)
				object3.x = coords.x
				object3.y = coords.y
			}

			function fadeIn() {
				simulation.opacity = 1
				prompt1.opacity = 0
				prompt2.opacity = 0
			}

			onPositionChanged: fadeIn()

			Timer {
				id: fadeInTimer
				interval: 2000
				onTriggered: flickarea.fadeIn()
			}
		}

		Rectangle {
			id: simulation

			anchors.fill: parent
			anchors.margins: 15
			color: "transparent"
			opacity: 0

			Behavior on opacity {
				NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
			}

			Rectangle {
				id: object1

				property double d: field_m1.value * 10 / 100

				width: d
				height: d
				z: 2
				radius: 100			
				color: "cyan"
			}

			Behavior on scale {
				NumberAnimation {
					duration: 200
					easing.type: Easing.OutQuad
				}
			}

			Rectangle {
				id: object2

				color: "red"
				width: 10
				height: 10
				radius: 10
			}

			Rectangle {
				id: object3
				color: "grey"
				width: 10
				height: 10
				radius: 5
				x: simulation.width / 2 - width / 2
				y: simulation.height / 2 - height / 2
			}

			Repeater {
				id: lagrange_points

				delegate: Components.LagrangePoint {
					x: modelData.x + simulation.width / 2 - width / 2
					y: modelData.y + simulation.height / 2 - height / 2
				}
			}
		}
	}

	Label {
		id: prompt1
		text: "Drag or pinch to interact"

		width: app.width
		anchors.centerIn: parent
		horizontalAlignment: Text.AlignHCenter
		font.pointSize: 30

		Behavior on opacity {
			NumberAnimation { duration: 1000; easing.type: Easing.InOutQuad }
		}
	}

	Label {
		id: prompt2
		text: "Click anywhere to place a third body"

		width: app.width
		anchors.top: app.top
		anchors.margins: app.spacing + 25
		horizontalAlignment: Text.AlignHCenter
		font.pointSize: 20

		SequentialAnimation {
			id: prompt2Animation
			
			NumberAnimation { target: prompt2; from: 0; to: 1; property: "opacity"; duration: 1000; easing.type: Easing.InOutQuad }
			NumberAnimation { target: prompt2; from: 1; to: 1; property: "opacity"; duration: 3000; easing.type: Easing.InOutQuad }
			NumberAnimation { target: prompt2; from: 1; to: 0; property: "opacity"; duration: 1000; easing.type: Easing.InOutQuad }
		}

		// function show(msg) {
		// 	text = msg
		// 	prompt2Animation.play()
		// }
	}

	MouseArea {
		id: invisible_titlebar

		z: 1
		anchors.top: parent.top
		width: parent.width
		height: 50
		acceptedButtons: Qt.LeftButton
		onPressed: Window.window.startSystemMove()	
	}

	RoundButton {
		id: menu_toggle

		z: 2
		icon.source: "assets/cog_icon.png"
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: app.spacing
		
		onClicked: {
			if (menu.state == "open") {
				menu.state = "closed"
			} else {
				menu.state = "open"
			}
		}
	}

	Label {
		id: aboutTxt
		text: "Lagrange point visualizer"

		width: app.width
		anchors.left: app.left
		anchors.bottom: app.bottom
		anchors.margins: app.spacing
		opacity: 0.7
		font.pointSize: 14
	}

	RoundButton {
		id: resize_toggle

		z: 2
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: app.spacing
		icon.source: "assets/resize_icon.png"
		opacity: 0.5

		onPressed: {
			Window.window.startSystemResize(Qt.BottomEdge | Qt.RightEdge)
		}
	}

	Rectangle {
		id: quitBtn

		width: 60
		height: 40
		z: 3
		anchors.right: parent.right
		anchors.top: parent.top
		color: mousearea.containsMouse ? "#300c33" : "#401f66"
		opacity: 0.8
		radius: app.radius
		anchors.margins: app.spacing
		
		Label {
			anchors.centerIn: parent
			text: "X"
		}

		MouseArea {
			id: mousearea

			anchors.fill: parent
			hoverEnabled: true

			onClicked: closeAnim.start()
		}
	}

	Component.onCompleted: {
		logicTimer.start()
		fadeInTimer.start()
		background.play()
	}
}