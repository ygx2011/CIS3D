Logically, the most important code snippets includes:
 1. ModelViewController - the event-driven loop
 2. CISSfM - manages the queues
 3. CISImagePair - match 2 images and 2d -> 3d

Conventions:
 u_{i}, i \in {L, R} -> 2D coordinate in image plane
 x_{i}, i \in {L, R} -> 2D homogeneous coordinate in world coordinates, (x_x, x_y, 1.0)
 X -> 3D coordinate in world coordinates