library(igraph)

############################################################################################
# first option (https://www.r-bloggers.com/2021/04/social-network-analysis-in-r/): 
# list of vertices = [aoc, user1, user2, etc]
# list of edges = [(aoc,user1), (aoc, user2), etc]

# create data frame
y <- data.frame(data$influencer, data$user_followers)

# create network
net <- graph.data.frame(y, directed=T)

# TODO need a not manual way
# vertices 
V(net)  
+ 52/52 vertices, named, from 4c03f50:
 [1] AA AB AF DD CD BA CB CC BC ED AE CA EB BF BB AC DC BD DB CF DF BE EA CE EE EF FF FD GB GC GD AD KA KF LC DA EC FA FB DE FC FE GA GE KB KC KD KE LB LA LD LE

# edges
E(net)
290/290 edges from 4c03f50 (vertex names):
  [1] AA->DD AB->DD AF->BA DD->DA CD->EC DD->CE CD->FA CD->CC BA->AF CB->CA CC->CA CD->CA BC->CA DD->DA ED->AD AE->AC AB->BA CD->EC CA->CC

 [20] EB->CC BF->CE BB->CD AC->AE CC->FB DC->BB BD->CF DB->DA DD->DA DB->DD BC->AF CF->DE DF->BF CB->CA BE->CA EA->CA CB->CA CB->CA CC->CA

 [39] CD->CA BC->CA BF->CA CE->CA AC->AD BD->BE AE->DF CB->DF AC->DF AA->DD AA->DD AA->DD CD-
....................................................................................
....................................................................................
[153] CA->CC CD->CC CA->CC BB->CC DF->CE CA->CE AE->GA DC->ED BB->ED CD->ED BF->ED DF->ED CC->KB AD->EA EF->EA CF->KC EE->BB CC->BB BC->BB

[172] CD->KD AE->CF DF->AC DF->AC ED->AC KA->CA BB->CA CB->CA CC->CA EB->CA BE->CC BE->CD CB->CD CB->KE ED->AB AB->KF BA->AF CC->AF CA->AF
+ ... omitted several edges

# label nodes
V(net)$label <- V(net)$name
V(net)$degree <- degree(net)

# create social graph
set.seed(222)
plot(net,
     vertex.color = 'green',
     vertext.size = 2,
     edge.arrow.size = 0.1,
     vertex.label.cex = 0.8)

# option: format it in different ways
plot(net,
     vertex.color = rainbow(52),
     vertex.size = V(net)$degree*0.4,
     edge.arrow.size = 0.1,
     layout=layout.fruchterman.reingold)  #layout option


# community detection: see higly interconnected nodes
net <- graph.data.frame(y, directed = F)
cnet <- cluster_edge_betweenness(net)
plot(cnet,
     net,
     vertex.size = 10,
     vertex.label.cex = 0.8)


#####################################################################
# second option: hit matrix   (not sure thats how its called)
#   inf1 inf2 inf3 inf4
# u1  0    0    1    0
# u2  1    0    0    0
# u3  0    0    0    1
# u4  0    0    1    0
# u5  1    1    0    0

# then -> 1 equals edge between row[i] X col[i]