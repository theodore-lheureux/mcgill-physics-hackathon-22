import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts
import QtMultimedia

import com.hackathon.base
import com.hackathon.position

import "./components" as Components

Rectangle {
	anchors.fill: parent
	color: "#121212"

	Base { id: base }
	Position { id: position }

	Timer {
		id: timer
		interval: 16
		repeat: true

		property double angle: 0

		// variables
		property double m1: field_m1.value  
		property double m2: field_m2.value  
		property double r: field_r.value 
		property double speed: 1
		// property double v: field_v.value
		// property double v_ang: field_v_ang.value

		property double x3: 500
		property double y3: 500

		property double speedup
	

		onTriggered: {	
			let barycenter = base.barycenter(m1, m2, r)
			let lagrange_dist = base.lagrange_dist(m1, m2, r)
			let t = base.rotation_period(m1, m2, barycenter.x, barycenter.y) * (speed)

			// place 2 first astres
			let posM1 = position.pos_object(angle, barycenter.x, true)
			object1.x = posM1.x + simulation.width / 2
			object1.y = posM1.y + simulation.height / 2

			let posM2 = position.pos_object(angle, barycenter.y, false)
			object2.x = posM2.x + simulation.width / 2
			object2.y = posM2.y + simulation.height / 2
			
			// place Lagrange pts
			let pos_lagrange = position.pos_lagrange(lagrange_dist[0], lagrange_dist[1], lagrange_dist[2], posM2.x, posM2.y, barycenter.x, r, angle)
			lagrange_points.model = pos_lagrange

			// // Place Object 3
			// let posM3 = position.pos_object3(m1, m2, object1.x, object1.y, object2.x, object2.y, object3.x, object3.y, v, v_ang, t)
			// object3.x = posM3.x
			// object3.y = posM3.y 

			angle += 0.005 * field_speed.value
		}
	}
	
	Pane {
		id: menu
		
		property int margin: 15

		width: layout.implicitWidth + margin * 4
		height: heading.implicitHeight + layout.implicitHeight + margin * 4
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: margin

		property int radius: 15
		Material.elevation: 100
		background: Rectangle {
			color: menu.Material.backgroundColor
			radius: menu.Material.elevation > 0 ? menu.radius : 0

			layer.enabled: menu.enabled && menu.Material.elevation > 0
			layer.effect: ElevationEffect {
				elevation: menu.Material.elevation
			}
		}	

		Label {
			id: heading

			text: "Parameters"
			font.pointSize: 30
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: menu.margin
			anchors.leftMargin: 40 // dirty hack
		}
		Column {
			id: layout

			anchors.top: heading.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: menu.margin
			
			Components.Slider {
				id: field_speed
				text: "Simulation speed"
				min: 1
				max: 10
				initial: 1
			}

			Components.Slider {
				id: field_m1
				text: "Mass of 1st object"
				min: 50
				max: 300
				initial: 31
			}

			Components.Slider {
				id: field_m2
				text: "Mass of 2nd object"
				min: 1
				max: 10
				initial: 1
			}

			Components.Slider {
				id: field_r
				text: "Distance b/w masses"
				min: 0
				max: 500
				initial: 70
			}

			// BROKEN
			// Components.Slider {
			// 	id: field_v
			// 	text: "Velocity of 3rd object"
			// 	min: -2 * Math.PI
			// 	max: 2 * Math.PI
			// 	initial: 0
			// }

			// Components.Slider {
			// 	id: field_v_ang
			// 	text: "Angle of velocity"
			// 	min: 0
			// 	max: 100
			// 	initial: 50
			// }

			// Components.Slider {
			// 	id: field_x3
			// 	text: "X of 3rd object"
			// 	min: 1
			// 	max: 100
			// 	initial: 50
			// }

			// Components.Slider {
			// 	id: field_y3
			// 	text: "Y of 3rd object"
			// 	min: 1
			// 	max: 100
			// 	initial: 50
			// }
		}

		state: "closed"
		states: [
			State {
				name: "open"
				PropertyChanges {
					target: menu
					width: layout.implicitWidth + margin * 4
					height: heading.implicitHeight + layout.implicitHeight + margin * 4
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
				duration: 200
				easing.type: Easing.InOutQuad
			}
		}
	}

	RoundButton {
		id: menu_toggle
		icon.source: "assets/cog_icon_mit.png"
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.margins: menu.margin
		
		onClicked: {
			if (menu.state == "open") {
				menu.state = "closed"
			} else {
				menu.state = "open"
			}
		}
	}

	Video {
		id: background

		anchors.fill: parent
		source: Qt.resolvedUrl("assets/video.mp4")
		playbackRate: 0.4 * timer.speed
		opacity: 0.3
		fillMode: Image.PreserveAspectCrop
	}

	Rectangle {
		id: simulation

		color: "transparent"

		anchors.fill: parent

		anchors.margins: 15

		// layer.enabled: true
		// layer.effect: ElevationEffect {
		// 	elevation: 100
		// }

		Rectangle {
			id: object1

			color: "blue"
			width: 10
			height: 10
			radius: 10			
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
			width: 20
			height: 20
			radius: 10
			x: simulation.width / 2
			y: + simulation.height / 2
		}

		Repeater {
			id: lagrange_points

			delegate: Components.LagrangePoint {
				x: modelData.x + simulation.width / 2
				y: modelData.y + simulation.height / 2
			}
		}
	}

	Component.onCompleted: {
		timer.start()
		background.play()
	}
}