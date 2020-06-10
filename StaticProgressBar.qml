import QtQuick 2.0

Canvas {
    width: parent.width
    height: 110
    anchors.bottom: footerrect.top
    anchors.bottomMargin: -10
    z: 1
    onPaint: {
        var ctx = getContext("2d")
        function drawBezierSplit(ctx, x0, y0, x1, y1, x2, y2, t0, t1) {

            if( 0.0 == t0 && t1 == 1.0 ) {
                ctx.moveTo( x0, y0 );
                ctx.quadraticCurveTo( x1, y1, x2, y2 );
                return
            } else if( t0 != t1 ) {
                var t00 = t0 * t0,
                    t01 = 1.0 - t0,
                    t02 = t01 * t01,
                    t03 = 2.0 * t0 * t01;

                var nx0 = t02 * x0 + t03 * x1 + t00 * x2,
                    ny0 = t02 * y0 + t03 * y1 + t00 * y2;

                t00 = t1 * t1;
                t01 = 1.0 - t1;
                t02 = t01 * t01;
                t03 = 2.0 * t1 * t01;

                var nx2 = t02 * x0 + t03 * x1 + t00 * x2,
                    ny2 = t02 * y0 + t03 * y1 + t00 * y2;

                var nx1 = lerp ( lerp ( x0 , x1 , t0 ) , lerp ( x1 , x2 , t0 ) , t1 ),
                    ny1 = lerp ( lerp ( y0 , y1 , t0 ) , lerp ( y1 , y2 , t0 ) , t1 );

                ctx.moveTo( nx0, ny0 );
                ctx.quadraticCurveTo( nx1, ny1, nx2, ny2 );
            }
        }

        /**
         * Linearly interpolate between two numbers v0, v1 by t
         */
        function lerp(v0, v1, t) {
            return ( 1.0 - t ) * v0 + t * v1;
        }
        ctx.lineJoin = 'round'
        ctx.lineWidth = 4
//            ctx.strokeStyle = "#1C70E4"
        ctx.strokeStyle = "#EEEEEE"
        ctx.fillStyle= "#FAFAFA"
//                    ctx.save();
        ctx.beginPath();
        ctx.moveTo(0, 100);
        ctx.lineTo(40 * (staticcanvas.width / 100), 100);
        drawBezierSplit(ctx, (40 * (staticcanvas.width / 100)) - 1, 100, (50 * (staticcanvas.width / 100)), 50, (60 * (staticcanvas.width / 100)), 100, 0, 1);
        ctx.lineTo(staticcanvas.width, 100);
//                    ctx.restore();
        ctx.fill()
//            ctx.globalAlpha=0.8
        ctx.stroke()
    }
    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: !filep.started ? "Ready!" : progresscanvas.value + "%"
        font.bold: Font.Bold
        font.pixelSize: 15
    }
}
