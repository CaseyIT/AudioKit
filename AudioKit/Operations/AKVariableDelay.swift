//
//  AKVariableDelay.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/11/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** A variable delay line

A delay line with cubic interpolation.
*/
@objc class AKVariableDelay : AKParameter {

    // MARK: - Properties

    private var vdelay = UnsafeMutablePointer<sp_vdelay>.alloc(1)

    private var input = AKParameter()

    /** The maximum delay time, in seconds. [Default Value: 5.0] */
    private var maximumDelayTime: Float = 0


    /** Delay time (in seconds) that can be changed during performance. This value must not exceed the maximum delay time. [Default Value: 1] */
    var delayTime: AKParameter = akp(1) {
        didSet { delayTime.bind(&vdelay.memory.del) }
    }


    // MARK: - Initializers

    /** Instantiates the delay with default values */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        bindAll()
    }

    /**
    Instantiates delay with constants

    - parameter maximumDelayTime: The maximum delay time, in seconds. [Default Value: 5.0]
 */
    init (input sourceInput: AKParameter, maximumDelayTime maxdelInput: Float) {
        super.init()
        input = sourceInput
        setup(maxdelInput)
        bindAll()
    }

    /**
    Instantiates the delay with all values

    - parameter input: Input audio signal. 
    - parameter delayTime: Delay time (in seconds) that can be changed during performance. This value must not exceed the maximum delay time. [Default Value: 1]
    - parameter maximumDelayTime: The maximum delay time, in seconds. [Default Value: 5.0]
    */
    convenience init(
        input            sourceInput: AKParameter,
        delayTime        delInput:    AKParameter,
        maximumDelayTime maxdelInput: Float)
    {
        self.init(input: sourceInput, maximumDelayTime: maxdelInput)
        delayTime        = delInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal delay */
    internal func bindAll() {
        delayTime       .bind(&vdelay.memory.del)
    }

    /** Internal set up function */
    internal func setup(maximumDelayTime: Float = 5.0)
 {
        sp_vdelay_create(&vdelay)
        sp_vdelay_init(AKManager.sharedManager.data, vdelay, maximumDelayTime)
    }

    /** Computation of the next value */
    override func compute() {
        sp_vdelay_compute(AKManager.sharedManager.data, vdelay, &(input.leftOutput), &leftOutput);
        sp_vdelay_compute(AKManager.sharedManager.data, vdelay, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_vdelay_destroy(&vdelay)
    }
}
