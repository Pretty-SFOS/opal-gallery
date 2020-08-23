import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaListView {
        id: view
        anchors.fill: parent
        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("About Opal")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutOpalPage.qml"))
            }
        }

        header: PageHeader {
            title: qsTr("Opal Gallery")
            description: qsTr("for form and function")
        }

        model: app.modules

        delegate: ListItem {
            id: listItem
            contentHeight: Math.max(Theme.itemSizeExtraLarge,
                                    contents.height+2*Theme.paddingMedium)
            menu: contextMenu
            onClicked: pageStack.push(Qt.resolvedUrl("../module-pages/"+examplePage))

            Column {
                id: contents
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top; topMargin: Theme.paddingSmall
                }

                Label {
                    text: title
                    wrapMode: Text.Wrap
                    width: parent.width
                }

                Label {
                    text: description
                    font.pixelSize: Theme.fontSizeSmall
                    color: highlighted ? Theme.secondaryHighlightColor
                                       : Theme.secondaryColor
                    wrapMode: Text.Wrap
                    textFormat: Text.StyledText
                    width: parent.width
                }
            }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("About")
                        onClicked: pageStack.push(Qt.resolvedUrl("AboutModulePageBase.qml"), {
                                                      appName: title,
                                                      description: description,
                                                      author: author,
                                                      mainLicenseSpdx: mainLicenseSpdx,
                                                      sourcesUrl: sourcesUrl
                                                  })
                    }
                }
            }
        }
    }
}
