public extension ObjectProcessorModifiers {
	/// The flat map modifier.
	///
	/// ## See Also
	/// - ``ObjectProcessor/flatMap(_:)``
	struct FlatMap<Input, SegmentOfResult>: ObjectProcessor where
		Input: Sequence,
		SegmentOfResult: Sequence
	{
		private let transform: (Input.Element) throws -> SegmentOfResult

		/// Create a flat map modifier.
		public init(_ transform: @escaping (Input.Element) throws -> SegmentOfResult) {
			self.transform = transform
		}

		public func process(_ input: Input) throws -> [SegmentOfResult.Element] {
			try input.flatMap(transform)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessor {
	/// Append a `flatMap` operation to the object processor.
	///
	/// ## See Also
	/// - ``ObjectProcessorModifiers/FlatMap``
	func flatMap<SegmentOfResult>(
		_ transform: @escaping (Self.Output.Element) throws -> SegmentOfResult
	) -> ModifiedObject<Self, ObjectProcessorModifiers.FlatMap<Self.Output, SegmentOfResult>> where
		Self.Output: Sequence,
		SegmentOfResult: Sequence
	{
		let modifier = ObjectProcessorModifiers.FlatMap<Self.Output, SegmentOfResult>(transform)
		return self.modifier(modifier)
	}
}
