use std::io::Write;
use anyhow::{Context, Result};
use petgraph::graph::{Graph, NodeIndex};
use petgraph::dot::{Dot, Config};
use std::fs;
use std::path::Path;

pub fn generate_graph(data: &[String], destination_folder: &str) -> Result<()> {
    let mut graph = Graph::<&str, &str>::new();

    // Add nodes and edges based on the input data
    let node_indices: Vec<NodeIndex> = data.iter().map(|line| graph.add_node(line.as_str())).collect();

    // Example: Connect first node to second node if both exist
    if node_indices.len() > 1 {
        graph.add_edge(node_indices[0], node_indices[1], "Edge between first and second");
    }

    // Create the destination folder if it does not exist
    let path = Path::new(destination_folder);
    if !path.exists() {
        fs::create_dir_all(path).context("Failed to create destination folder")?;
    }

    // Generate a .dot file for Graphviz
    let dot_file_path = path.join("output_graph.dot");
    let mut dot_file = fs::File::create(dot_file_path)?;
    writeln!(dot_file, "{:?}", Dot::with_config(&graph, &[Config::EdgeNoLabel]))?;

    Ok(())
}

