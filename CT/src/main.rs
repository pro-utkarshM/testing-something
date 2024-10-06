use clap::{Arg, Command};
use std::fs;

mod graph;
mod parser;
mod type_checker;

fn main() -> anyhow::Result<()> {
    let matches = Command::new("ct")
        .version("1.0")
        .about("Something I am doing :Q")
        .arg(
            Arg::new("input")
                .short('i')
                .long("input")
                .takes_value(true)
                .required(true)
                .about("Input file to process"),
        )
        .arg(
            Arg::new("destination_folder")
                .short('d')
                .long("destination_folder")
                .takes_value(true)
                .about("Output folder for results"),
        )
        .get_matches();

    let input_file = matches.value_of("input").unwrap();
    let destination_folder = matches.value_of("destination_folder").unwrap_or("./output");

    // Read and process the input file
    let input_data = fs::read_to_string(input_file)?;
    let parsed_data = parser::parse(&input_data)?;
    let type_checked_data = type_checker::type_check(parsed_data)?;

    // Generate the graph visualization
    graph::generate_graph(&type_checked_data, destination_folder)?;

    Ok(())
}

