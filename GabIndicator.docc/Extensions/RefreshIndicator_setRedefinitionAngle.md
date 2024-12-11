# ``GabIndicator/RefreshIndicator/setRedefinitionAngle(angle:_:)``


##### setAngle과 다른점

@TabNavigator {
    @Tab(setRedefinitionAngle) {
        @Row {
            @Column {
                ```swift
                RefreshIndicator()
                    .strokeStyle(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .setRedefinitionAngle(angle: 41)
                    .frame(width: 50, height: 50)
                ```
            }
            
            @Column {
                ![setRedefinitionAngle 사진](setRedefinitionAngle_refreshIndicator.png)
            }
        }
    }
    
    @Tab(setAngle) {
        @Row {
            @Column {
                ```swift
                RefreshIndicator()
                    .strokeStyle(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .setAngle(angle: 41)
                    .frame(width: 50, height: 50)
                ```
            }
            
            @Column {
                ![setAngle 사진](setAngle_refreshIndicator.png)
            }
        }
    }
}
