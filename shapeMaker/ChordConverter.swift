import Foundation
import Tonic
import HandSynthLibrary

extension Pattern {
    func toSpatialChords() -> [SpatialChord] {
        // First, detect likely key from pattern notes
        let allNotes = patternNotes.flatMap { $0 }.map { $0.note }
        let noteSet = Set(allNotes.map { $0.noteClass })
        
        // Find key that contains most of these notes
        let possibleKeys: [Key] = [.C, .G, .D, .A, .E, .B, .Fs, 
                                  .Cs, .F, .Bb, .Eb, .Ab, .Db, .Gb]
        let bestKey = possibleKeys.max(by: { a, b in
            let aMatches = a.noteSet.intersection(noteSet).count
            let bMatches = b.noteSet.intersection(noteSet).count
            return aMatches < bMatches
        }) ?? .C
        
        // Convert each chord in pattern to SpatialChord
        return patternNotes.map { chordNotes in
            let adjustedNotes = chordNotes.map { note -> Int in
                // Convert note to scale degree in detected key
                let scaleDegree = bestKey.noteSet.firstIndex(of: note.note.noteClass) ?? 0
                
                // Calculate base note number (0-27 range represents 4 octaves)
                var noteNumber = scaleDegree + (note.octave * 7) // 7 notes per octave in key
                
                // Adjust octave if out of range
                while noteNumber < 0 {
                    noteNumber += 7
                }
                while noteNumber > 27 {
                    noteNumber -= 7
                }
                
                return noteNumber
            }
            
            return SpatialChord(adjustedNotes)
        }
    }
}
