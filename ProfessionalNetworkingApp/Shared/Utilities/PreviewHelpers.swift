// PreviewHelpers.swift

#if DEBUG
import SwiftUI

// A tiny wrapper to provide a Binding/State in SwiftUI previews
public struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    public init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: initialValue)
        self.content = content
    }

    public var body: some View {
        content($value)
    }
}
#endif
