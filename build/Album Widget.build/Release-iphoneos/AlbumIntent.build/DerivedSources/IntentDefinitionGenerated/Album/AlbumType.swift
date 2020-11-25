//
// AlbumType.swift
//
// This file was automatically generated and should not be edited.
//

#if canImport(Intents)

import Intents

@available(iOS 12.0, macOS 10.16, watchOS 5.0, *) @available(tvOS, unavailable)
@objc(AlbumType)
public class AlbumType: INObject {

    @available(iOS 13.0, macOS 10.16, watchOS 6.0, *)
    @NSManaged public var index: NSNumber?

}

@available(iOS 13.0, macOS 10.16, watchOS 6.0, *) @available(tvOS, unavailable)
@objc(AlbumTypeResolutionResult)
public class AlbumTypeResolutionResult: INObjectResolutionResult {

    // This resolution result is for when the app extension wants to tell Siri to proceed, with a given AlbumType. The resolvedValue can be different than the original AlbumType. This allows app extensions to apply business logic constraints.
    // Use notRequired() to continue with a 'nil' value.
    @objc(successWithResolvedAlbumType:)
    public class func success(with resolvedObject: AlbumType) -> Self {
        return super.success(with: resolvedObject) as! Self
    }

    // This resolution result is to ask Siri to disambiguate between the provided AlbumType.
    @objc(disambiguationWithAlbumTypesToDisambiguate:)
    public class func disambiguation(with objectsToDisambiguate: [AlbumType]) -> Self {
        return super.disambiguation(with: objectsToDisambiguate) as! Self
    }

    // This resolution result is to ask Siri to confirm if this is the value with which the user wants to continue.
    @objc(confirmationRequiredWithAlbumTypeToConfirm:)
    public class func confirmationRequired(with objectToConfirm: AlbumType?) -> Self {
        return super.confirmationRequired(with: objectToConfirm) as! Self
    }

    @available(*, unavailable)
    override public class func success(with resolvedObject: INObject) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    override public class func disambiguation(with objectsToDisambiguate: [INObject]) -> Self {
        fatalError()
    }

    @available(*, unavailable)
    override public class func confirmationRequired(with objectToConfirm: INObject?) -> Self {
        fatalError()
    }

}

#endif
