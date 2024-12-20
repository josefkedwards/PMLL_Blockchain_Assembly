# include.s: Central reference for modular assembly components

# Section to include external modular files
.extern PMLL_loop         # Persistent Memory Logic Loop (pmll.s)
.extern init_variables    # Variable initialization (variable.s)
.extern init_graph        # Graph initialization (Create_Graph.s)
.extern create_graph      # Graph creation function (Create_Graph.s)
.extern write_node        # Node writing function (Create_Graph.s)
.extern connect_nodes     # Connect two nodes in a graph (Create_Graph.s)
.extern print_counter     # Print JKE_counter (printf.s)
.extern debug             # Debugging utility (debug.s)
.extern ASCII_to_screen   # ASCII to screen rendering (ASCII.s)
.extern handle_null       # NULL pointer handling (NULL.s)
.extern write_array       # Write array logic (write_array.s)
.extern link_nodes        # Link nodes in a logic graph (link.s)
.extern init_window       # Initialize terminal window (window.s)
.extern render_screen     # Render a screen display (screen.s)

# Add other components as needed
