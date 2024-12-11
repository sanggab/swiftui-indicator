# ``GabIndicator/RefreshIndicator/setAngle(angle:)``


##### 360도를 나눈 값에 따른 RefreshIndicator의 UI 차이점

@TabNavigator {
    @Tab(정수) {
        @Row {
            @Column {
                ```swift
                RefreshIndicator()
                    .strokeStyle(style: StrokeStyle(lineWidth: 10,
                                                    lineCap: .round,
                                                    lineJoin: .round))
                    .setAngle(angle: 36)
                    .frame(width: 50, height: 50)
                ```
            }
            
            @Column {
                ![정수 사진](integer_refreshIndicator.png)
            }
        }
    }
    
    @Tab(유리수) {
        @Row {
            @Column {
                ```swift
                RefreshIndicator()
                    .strokeStyle(style: StrokeStyle(lineWidth: 10,
                                                    lineCap: .round,
                                                    lineJoin: .round))
                    .setAngle(angle: 33)
                    .frame(width: 50, height: 50)
                ```
            }
            
            @Column {
                ![유리수 사진](rational_refreshIndicator.png)
            }
        }
    }
}
