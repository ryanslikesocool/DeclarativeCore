#if canImport(Foundation)
import Foundation
#endif

public extension ObjectProcessorModifiers {
	/// ## See Also
	/// - ``ObjectProcessor/sort(by:)-2an6i``
	/// - ``ObjectProcessor/sort(by:)-6vxby``
	/// - ``ObjectProcessor/sort(using:)``
	struct Sort<Input>: ObjectProcessor where
		Input: Sequence
	{
		public typealias Output = [Input.Element]

		private let areInIncreasingOrder: (Input.Element, Input.Element) throws -> Bool

		public init(by areInIncreasingOrder: @escaping (Input.Element, Input.Element) throws -> Bool) {
			self.areInIncreasingOrder = areInIncreasingOrder
		}

		public func process(_ input: Input) throws -> Output {
			try input.sorted(by: areInIncreasingOrder)
		}
	}
}

// MARK: - Convenience

public extension ObjectProcessorModifiers.Sort {
	init<Compared>(by keyPath: KeyPath<Input.Element, Compared>) where
		Compared: Comparable
	{
		self.init { (lhs: Input.Element, rhs: Input.Element) -> Bool in
			lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
		}
	}

#if canImport(Foundation)
	@available(iOS 15, macCatalyst 15, macOS 12, tvOS 15, watchOS 8, *)
	init<Comparator>(using comparator: Comparator) where
		Comparator: SortComparator,
		Comparator.Compared == Input.Element
	{
		self.init { (lhs: Input.Element, rhs: Input.Element) -> Bool in
			comparator.compare(lhs, rhs) == .orderedAscending
		}
	}
#endif
}

public extension ObjectProcessor {
	/// Append a `sort` operation to the object processor.
	func sort(
		by areInIncreasingOrder: @escaping (Self.Output.Element, Self.Output.Element) throws -> Bool
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Sort<Self.Output>> where
		Self.Output: Sequence
	{
		let modifier = ObjectProcessorModifiers.Sort<Self.Output>(by: areInIncreasingOrder)
		return self.modifier(modifier)
	}

	/// Append a `sort` operation to the object processor.
	func sort<Compared>(
		by keyPath: KeyPath<Self.Output.Element, Compared>
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Sort<Self.Output>> where
		Self.Output: Sequence,
		Compared: Comparable
	{
		let modifier = ObjectProcessorModifiers.Sort<Self.Output>(by: keyPath)
		return self.modifier(modifier)
	}

#if canImport(Foundation)
	/// Append a `sort` operation to the object processor.
	@available(iOS 15, macCatalyst 15, macOS 12, tvOS 15, watchOS 8, *)
	func sort<Comparator>(
		using comparator: Comparator
	) -> ModifiedObject<Self, ObjectProcessorModifiers.Sort<Self.Output>> where
		Self.Output: Sequence,
		Comparator: SortComparator,
		Comparator.Compared == Self.Output.Element
	{
		let modifier = ObjectProcessorModifiers.Sort<Self.Output>(using: comparator)
		return self.modifier(modifier)
	}
#endif
}
