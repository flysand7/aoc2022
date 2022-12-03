
package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
    data_bytes, ok := os.read_entire_file("input.txt")
    input_str := cast(string) data_bytes
    elf_calo_top : [3]int
    elf_count := 0
    for {
        // Count up elf's calories
        elf_calo := 0
        for line in strings.split_by_byte_iterator(&input_str, '\n') {
            if(line == "") {
                break;
            } else {
                calo, ok := strconv.parse_int(line)
                if !ok {
                    fmt.println("[ERROR]: unexpected input format\n")
                }
                elf_calo += calo
            }
        }
        // Fill up and sort the top 3 calorie scores
        if elf_count < len(elf_calo_top) {
            elf_calo_top[elf_count] = elf_calo
        }
        if elf_count == len(elf_calo_top) {
            slice.sort(elf_calo_top[:])
        }
        // If needed insert new elf's calorie score into the top
        top_insert := false
        top_index  := 0
        if elf_calo > elf_calo_top[0] {
            top_insert = true
        }
        for top_index = 0; top_index < len(elf_calo_top)-1; top_index += 1 {
            if elf_calo <= elf_calo_top[top_index+1] {
                break
            } else {
                elf_calo_top[top_index] = elf_calo_top[top_index+1]
            }
        }
        if top_insert {
            elf_calo_top[top_index] = elf_calo
        }
        elf_count += 1
        // If no one left we take a leave and go print the result
        if input_str == "" {
            break;
        }
    }
    fmt.println("[top calorie counts]:", elf_calo_top)
    fmt.println("[total]:", math.sum(elf_calo_top[:]))
}
