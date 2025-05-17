//
//  SamplePatch.swift
//  shapeMaker
//
//  Created by Jack Brodie on 15/05/2025.
//

import HandSynthLibrary
import Tonic

let samplePatch = Patch(
    pattern: Pattern(
        name: "Spatial Chord Progression",
        key: .C,                  // Explicitly set key for spatial mapping
        octBound: 3...6,         // Keep notes within VR comfortable height range
        patternNotes: [
            // C major (root position)
            [ChordNote(note: .C, octave: 3),
             ChordNote(note: .E, octave: 4),
             ChordNote(note: .G, octave: 5)],
            
            // A minor (first inversion)
            [ChordNote(note: .C, octave: 4),
             ChordNote(note: .E, octave: 3),
             ChordNote(note: .A, octave: 3)],
            
            // F major (root position)
            [ChordNote(note: .F, octave: 3),
             ChordNote(note: .A, octave: 3),
             ChordNote(note: .C, octave: 4)],
            
            // G major (second inversion)
            [ChordNote(note: .D, octave: 3),
             ChordNote(note: .G, octave: 3),
             ChordNote(note: .B, octave: 3)]
        ]
    ),
    config: PatchConfig(
        name: "Spatial Synth Default",
        defaultMod: 0.2,
        tie: true,
        volume: 0.8
    ),
    preset: Preset(
        filename: "galaxy",
        ext: .aupreset
    ),
    metadata: PatchMetadata(
        desc: "",
        titleHumanReadable: "",
        author: "Jack Brodie"
    )
)
