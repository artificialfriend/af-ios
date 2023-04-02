//
//  AITextView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct AITextView: View {
    let responseText: String = "Orville Wright: Pioneering Aviator and Inventor\nOrville Wright was a renowned aviation pioneer, inventor, and businessman. Born on August 19, 1871, in Dayton, Ohio, Orville was the younger of the two Wright brothers, the other being Wilbur Wright. Together, the Wright brothers revolutionized the aviation industry and changed the course of history.\nOrville grew up in a family that valued education and encouraged curiosity. His father, Milton Wright, was a bishop in the United Brethren Church, and his mother, Susan Catherine Koerner, was from a family of German immigrants. As children, Orville and Wilbur were fascinated with science and mechanics, and they often conducted experiments in their backyard.\nIn 1892, Orville and Wilbur opened a bicycle sales and repair shop in Dayton. It was during this time that they began to develop an interest in aviation. They followed the works of famous inventors and engineers of the time, such as Octave Chanute and Samuel Langley, and studied the principles of flight.\nIn 1900, the Wright brothers began their work on designing and building their own aircraft. They spent countless hours experimenting with different materials, wing shapes, and propulsion methods. They also developed their own wind tunnel, which allowed them to test their designs and gather data on aerodynamics.\nFinally, in 1903, the Wright brothers made history by successfully flying the first powered aircraft. Orville piloted the plane, which took off from Kitty Hawk, North Carolina, and stayed in the air for 12 seconds, covering a distance of 120 feet. It was a momentous achievement that would change the world forever.\nOver the next few years, the Wright brothers continued to refine their aircraft designs and make more significant flights. In 1905, they flew a plane for more than 30 minutes, which was a record at the time. In 1908, they traveled to France, where they made numerous public flights and impressed aviation enthusiasts across the continent.\nOrville and Wilbur also filed for numerous patents related to their aircraft designs, including the wing-warping technique that allowed for lateral control of the plane. They were astute businessmen as well and formed the Wright Company in 1909 to manufacture and sell their aircraft.\nSadly, Wilbur died of typhoid fever in 1912, leaving Orville to carry on their legacy alone. Orville continued to design and build aircraft for the rest of his life, and he also served as an advocate for aviation and a pioneer of aviation safety. He passed away on January 30, 1948, at the age of 76.\nOrville Wright's legacy is one of innovation, determination, and ingenuity. He and his brother Wilbur changed the course of history and opened up new possibilities for human travel and exploration. Today, we continue to build on their work and explore new frontiers in aviation and space travel, inspired by the Wright brothers' pioneering spirit."
    
    @State private var textArray: [String] = []
    @State private var title: String = ""
    @State private var paragraphs: [String] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.l)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                ForEach(paragraphs, id: \.self) { p in
                    Text(p)
                        .font(.p)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .foregroundColor(.afBlack)
        .padding(.horizontal, s16)
        .onAppear { parseTextResponse() }
        
    }
    
    func parseTextResponse() {
        textArray = responseText.components(separatedBy: "\n")
        title = textArray[0]
        textArray.remove(at: 0)
        paragraphs = textArray
    }
}
