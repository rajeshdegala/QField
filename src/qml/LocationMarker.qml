import QtQuick 2.0
import org.qgis 1.0
import Theme 1.0

Item {
  id: item

  property variant location // QgsPointV2
  property real accuracy
  property real direction // A -1 value indicates absence of direction information
  property MapSettings mapSettings

  Rectangle {
    id: accuracyMarker
    property point location
    property real accuracy
    visible: accuracy > 0.0
    width: accuracy
    height: accuracy

    x: location.x - width/2
    y: location.y - height/2

    radius: width/2

    color: "#44AD1457"
    border.color: "#60880E4F"
    border.width: 0.7 * dp
  }

  Image {
    id: directionMarker
    property point location
    property real direction
    width: 48 * dp
    height: 48 * dp

    x: location.x - width/2
    y: location.y - height

    source: Theme.getThemeVectorIcon( "ic_gps_direction" )
    fillMode: Image.PreserveAspectFit
    rotation: direction
    transformOrigin: Item.Bottom
    smooth: true
  }

  Rectangle {
    id: marker
    property point location
    width: 10*dp
    height: 10*dp

    x: location.x - width/2
    y: location.y - height/2

    radius: width/2

    border.color: "#880E4F"
    border.width: 0.7 * dp

    gradient: Gradient  {
      GradientStop  {
        position: 0.0
        color: "#ffffff"
        SequentialAnimation on color  {
          loops: Animation.Infinite
          ColorAnimation  { from: "#AD1457"; to: "#FCE4EC"; duration: 3000; easing.type: Easing.InOutQuad }
          ColorAnimation  { from: "#FCE4EC"; to: "#AD1457"; duration: 2000; easing.type: Easing.InOutQuad }
        }
      }
      GradientStop  {
        position: 1.0
        SequentialAnimation on color  {
          loops: Animation.Infinite
          ColorAnimation  { from: "#FCE4EC"; to: "#AD1457"; duration: 3000; easing.type: Easing.InOutQuad }
          ColorAnimation  { from: "#AD1457"; to: "#FCE4EC"; duration: 2000; easing.type: Easing.InOutQuad }
        }
      }
    }
  }

  Connections {
    target: mapSettings
    onExtentChanged: {
      marker.location = mapSettings.coordinateToScreen( location )
      directionMarker.location = mapSettings.coordinateToScreen( location )
      directionMarker.direction = direction
      accuracyMarker.location = mapSettings.coordinateToScreen( location )
      accuracyMarker.accuracy = accuracy / mapSettings.mapUnitsPerPixel
    }
  }

  onLocationChanged: {
    marker.location = mapSettings.coordinateToScreen( location );
    directionMarker.location = mapSettings.coordinateToScreen( location )
    directionMarker.direction = direction
    accuracyMarker.location = mapSettings.coordinateToScreen( location )
    accuracyMarker.accuracy = accuracy / mapSettings.mapUnitsPerPixel
  }
}
