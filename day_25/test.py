import networkx as nx
file1 = open('input.txt', 'r')
lines = file1.readlines()
G = nx.Graph()
for line in lines:
    row = line.strip().split(':')
    for target in row[1].strip().split():
        G.add_edge(row[0].strip(), target)

costs = []
for edge in G.edges:
    G.remove_edge(*edge)
    costs.append((edge, nx.shortest_path_length(G, *edge)))
    G.add_edge(*edge)

costs = sorted(costs, key=lambda x: x[1], reverse=True)
[G.remove_edge(*costs[i][0]) for i in range(3)]

print(f"removing {costs[0][0]} {costs[1][0]} {costs[2][0]}")
print(f"part1 {len(nx.node_connected_component(G, costs[0][0][0])) * len(nx.node_connected_component(G, costs[0][0][1]))}")
# removing ('kdk', 'nct') ('cvx', 'tvj') ('spx', 'fsv')
# part1 532891