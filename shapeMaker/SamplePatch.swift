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
        baseOctave: 1,            // Changed from octBound: 3...6
        patternNotes: [
            // C major (spread voicing)
            [ChordNote(note: .C, octave: 2),
             ChordNote(note: .E, octave: 3),
             ChordNote(note: .G, octave: 4),
             ChordNote(note: .C, octave: 5)],
            
            // D minor
            [ChordNote(note: .D, octave: 3),
             ChordNote(note: .F, octave: 3),
             ChordNote(note: .A, octave: 4),
             ChordNote(note: .D, octave: 5)],
            
            // E minor
            [ChordNote(note: .E, octave: 2),
             ChordNote(note: .G, octave: 3),
             ChordNote(note: .B, octave: 4),
             ChordNote(note: .E, octave: 5)],
            
            // F major
            [ChordNote(note: .F, octave: 2),
             ChordNote(note: .A, octave: 3),
             ChordNote(note: .C, octave: 4),
             ChordNote(note: .F, octave: 5)],
            
            // G major
            [ChordNote(note: .G, octave: 2),
             ChordNote(note: .B, octave: 3),
             ChordNote(note: .D, octave: 4),
             ChordNote(note: .G, octave: 5)],
            
            // A minor
            [ChordNote(note: .A, octave: 2),
             ChordNote(note: .C, octave: 3),
             ChordNote(note: .E, octave: 4),
             ChordNote(note: .A, octave: 5)],
            
            // B diminished
            [ChordNote(note: .B, octave: 2),
             ChordNote(note: .D, octave: 3),
             ChordNote(note: .F, octave: 4),
             ChordNote(note: .B, octave: 4)],
            
            // C major (full stack)
            [ChordNote(note: .C, octave: 2),
             ChordNote(note: .E, octave: 2),
             ChordNote(note: .G, octave: 3),
             ChordNote(note: .C, octave: 4),
             ChordNote(note: .E, octave: 5),
             ChordNote(note: .G, octave: 5)]
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
