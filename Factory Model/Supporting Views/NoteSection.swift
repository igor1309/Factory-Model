//
//  NoteSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.08.2020.
//

import SwiftUI

struct NoteSection: View {
    @Binding var note: String
    
    var body: some View {
        Section(
            header: Text("Note")
        ) {
            TextEditor(text: $note)
                .foregroundColor(.secondary)
        }
    }
}
