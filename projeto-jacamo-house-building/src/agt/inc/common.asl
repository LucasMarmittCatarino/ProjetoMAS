i_am_winning(Art)
   :- currentWinner(W)[artifact_id(Art)] &
      .my_name(Me) & .term2string(Me,MeS) & W == MeS.

currentBid(V)[artifact_id(Art)]
   :- currentPrice(V)[artifact_id(Art)].

+!discover_art(ToolName)
   <- lookupArtifact(ToolName,ToolId);
      focus(ToolId).
-!discover_art(ToolName)
   <- .wait(100);
      !discover_art(ToolName).

+!bid(Art)
   <- .send(Art, bid, .my_name).

+!accept(Art)
   <- .send(Art, accept, .my_name).