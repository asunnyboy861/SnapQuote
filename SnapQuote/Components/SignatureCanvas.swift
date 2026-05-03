import SwiftUI
import PencilKit

struct SignatureCanvas: UIViewRepresentable {
    @Binding var signatureData: Data?

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.tool = PKInkingTool(.pen, color: .black, width: 2)
        canvas.backgroundColor = .white
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: Coordinator) {}

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: SignatureCanvas

        init(_ parent: SignatureCanvas) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if canvasView.drawing.bounds.isEmpty {
                parent.signatureData = nil
            } else {
                let image = canvasView.drawing.image(from: canvasView.bounds, scale: 2.0)
                parent.signatureData = image.pngData()
            }
        }
    }
}
