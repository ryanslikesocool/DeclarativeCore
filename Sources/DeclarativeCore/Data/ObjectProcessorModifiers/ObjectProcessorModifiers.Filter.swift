#if canImport(Foundation)
import Foundation
#endif

public extension ObjectProcessorModifiers {
	/// The filter modifier.
	///
	/// ## See Also
	/// - ``ObjectProcessor/filter(_:)``
	/// - ``ObjectProcessor/filter(using:)``
	struct Filter<Input>: ObjectProcessor where
		Input: Sequence
	{
		public typealias Output = [Input.Element]

		private let isIncluded: (Input.Element) throws -> Bool

		/// Create a filter modifier.
		public init(_ isIncluded: @escaping (Input.Element) throws -> Bool) {
			self.isIncluded = isIncluded
		}

		public func process(_ input: Input) throws -> Output {
			try input.filter(isIncluded)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessorModifiers.Filter {
#if canImport(Foundation)
	/// Create a filter modifier.
	@available(iOS 17, macCatalyst 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
	init(using predicate: Predicate<Self.Output.Element>) {
		self.init(predicate.evaluate(_:))
	}
#endif
}

public extension ObjectProcessor {
	/// Append a `filter` operation to the object processor.
	///
	/// ## See Also
	/// - ``ObjectProcessorModifiers/Filter``
	func filter(
		_ isIncluded: @escaping (Self.Output.Element) throws -> Bool
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Filter<Self.Output>> where
		Self.Output: Sequence
	{
		let modifier = ObjectProcessorModifiers.Filter<Self.Output>(isIncluded)
		return self.modifier(modifier)
	}

#if canImport(Foundation)
	/// Append a `filter` operation to the object processor.
	///
	/// ## See Also
	/// - ``ObjectProcessorModifiers/Filter``
	@available(iOS 17, macCatalyst 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
	func filter(
		using predicate: Predicate<Self.Output.Element>
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Filter<Self.Output>> where
		Self.Output: Sequence
	{
		let modifier = ObjectProcessorModifiers.Filter<Self.Output>(using: predicate)
		return self.modifier(modifier)
	}
#endif
}
