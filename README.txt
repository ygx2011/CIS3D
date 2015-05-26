Logically, the most important code snippets includes:
 1. ModelViewController - the event-driven loop.
 2. CISSfM & CISSfM+Update - manages the queues and camera position reconstruction.

Conventions:
 u_{i}, i \in {L, R} -> 2D coordinate in image plane
 x_{i}, i \in {L, R} -> 2D homogeneous coordinate in world coordinates, (x_x, x_y, 1.0)
 X -> 3D coordinate in world coordinates