
maze = [[1, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 2]]

def search(maze):

    current_distance = 0

    unvisited = {}
    visited = {}

    while True:

        # Get neighbors
        up, down = (current[0] - 1, current[1]), (current[0] + 1, current[1])
        left, right = (current[0], current[1] - 1), (current[0], current[1] + 1)

        neighbors = [item for item in [up, down, left, right] if item[0] >= 0 and item[0] <= len(maze) - 1 and item[1] >= 0 and item[1] <= len(maze[len(maze)-1])-1]

        # Create new distance
        new_distance += current_distance + 1

        # Run through all 

        break


if __name__ == '__main__':
    search(maze)