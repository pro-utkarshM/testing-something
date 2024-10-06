use clap::{Arg, Command};
use std::fs;

mod graph;
mod parser;
mod type_checker;

fn main() -> anyhow::Result<()> {
    let matches = Command::new("ct")
        .version("1.0")
        .about("A Rust implementation of GCT")
        .arg(
            Arg::new("input")
                .short('i')
                .long("input")
                .required(true)
                .value_name("INPUT")
                .help("Input file to process"),
        )
        .arg(
            Arg::new("destination_folder")
                .short('d')
                .long("destination_folder")
                .value_name("DESTINATION_FOLDER")
                .help("Output folder for results"),
        )
        .get_matches();

    // Create a binding for the default value
    let default_destination = "./output".to_string();
    
    let input_file = matches.get_one::<String>("input").unwrap();
    
    // Use the binding instead of creating a temporary value
    let destination_folder = matches.get_one::<String>("destination_folder").unwrap_or(&default_destination);

    // Read and process the input file
    let input_data = fs::read_to_string(input_file)?;
    let parsed_data = parser::parse(&input_data)?;
    let type_checked_data = type_checker::type_check(parsed_data)?;

    // Generate the graph visualization
    graph::generate_graph(&type_checked_data, destination_folder)?;

    Ok(())
}

