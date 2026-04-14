use std::io::{Write, stdin, stdout};

fn main() {
    let running = false;

    while running {
        let player_choice: u8 = get_player_choice();

        match player_choice {
            1 => {
                
            }
            2 => {

            }
            3 => {

            }
            _ => {

            }
        }
    }
}

fn get_player_choice() -> u8 {
    println!("R(1), P(2, C(3)): ");
    stdout().flush().unwrap();

    let mut input = String::new();
    stdin().read_line(&mut input).unwrap();

    let choice = input.trim();
    let choice_num : u8 = choice.parse().unwrap();
    return choice_num;
}

fn get_cpu_choice() -> u8 {
    std::
}
