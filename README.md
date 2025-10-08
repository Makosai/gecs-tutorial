# gecs-tutorial 

The goal is to create a working prototype for new users. Not everything needs to use ECS. Some things are best done with a pure `node` and `signals` system.

We'll be completing the following tasks in a 3D environment while only worrying about the latest current phase. So if you're on phase 2, we'll worry about phase 1 and 2 but not 3, 4, 5, or 6. Each phase will be fully functional before moving on to the next phase.

## Phase 1: CRUD Operations
1. Create a play button.
2. When the button is clicked, load a new scene with a room that has 4 walls and a floor and a sun.
3. When the new scene is loaded, we'll begin performing CRUD operations.
   1. Create a player entity.
   2. Read the player entity and log its details.
   3. Update the player entity's details: position, health, score, and xp.
   4. Read the updated player entity and log its new details.
   5. Delete the player entity.
   6. Attempt to read the deleted player entity and log the result.

## Phase 2: Player Movement and Spell Casting
1. Create a player entity.
   1. The player should have a position component.
   2. The player should have a health component.
   3. The player should have a score component.
   4. The player should have an xp component.
   5. Think about if some of the data should be grouped into a single component.
2. Implement player movement.
   1. The player should be able to move forward, backward, left, and right using the W, A, S, and D keys.
   2. The player should be able to jump using the spacebar.
   3. If the player, or any entity, moves outside the room, reset their position to the center of the room.
3. Implement spell casting.
   1. The player should be able to cast a spell by clicking the left mouse button.
   2. When the spell is cast, create a spell entity at the player's position.
   3. The spell entity should move forward in the direction the player is facing.
   4. If the spell entity collides with the wall, an enemy, or a crate, destroy the spell entity and log a message to the console indicating what it hit.
   5. If the spell entity moves outside the room, destroy the spell entity.
   6. The spell entity should have a lifespan of 3 seconds before it is automatically destroyed.
   7. The spell has a cooldown of 0.5 seconds before the player can cast another spell.
   8. When the spell is cast, log a message to the console indicating that the spell was cast.
   9. When the spell is cast, play a sound effect.
4. Implement camera controls.
   1. The camera should follow the player from a third-person perspective.
   2. The camera should rotate around the player based on mouse movement.
   3. The camera should zoom in and out based on the mouse scroll wheel.


## Phase 3: Combat and Score System
1. Create a health system.
   1. The player should have a health component.
   2. The player should start with 100 health points.
   3. When the player collides with an enemy, reduce the player's health by the enemy's damage value and log the new health to the console.
   4. When the player collides with a crate, destroy the crate and increase the player's score by the crate's score value and log the new score to the console.
   5. If the player's health reaches 0, log a "Game Over" message to the console.
2. Create an enemy entity.
   1. The enemy should have a health component.
   2. The enemy should have a position component.
   3. The enemy should have a score value of 5 points when destroyed.
   4. The enemy should have a damage value of 10 points for whenever it collides with the player.
   5. When an enemy collides with the player, reduce the player's health by the enemy's damage value and log the new health to the console.
   6. When an enemy collides with the player, reset their position.
   7. When the player casts a spell and hits an enemy, reduce the enemy's health by 20 points and log the new health to the console.
   8. If the enemy's health reaches 0, destroy the enemy, increase the player's score by the enemy's score value, and log the new score to the console.
   9. Spawn a new enemy at a random position within the room every 10 seconds.
   10. The enemy should move towards the player at a slow speed.
   11. If the enemy collides with the player, it should stop moving for 2 seconds before resuming its movement towards the player.
3.  Create a crate entity.
   1. The crate should have a position component.
   2. The crate should have a score value of 2 points when destroyed.
   3. When the player collides with a crate, destroy the crate, increase the player's score by the crate's score value, and log the new score to the console.
   4. Spawn a new crate at a random position within the room every 15 seconds.


## Phase 4: Leveling System
1. The player should have an xp component.
2. The player should start with 0 xp points.
3. When the player destroys an enemy, increase the player's xp by 10 points and log the new xp to the console.
4. The player can pick up 2 items from crates. One is a health potion that restores 20 health points, and the other is an xp potion that grants 15 xp points. They can be used by pressing the 1 and 2 keys, respectively.
5. When the player reaches 100 xp points, increase the player's level by 1, reset the player's xp to 0, and log a "Level Up" message to the console.
6. When the player levels up, increase the player's health by 20 points and log the new health to the console.
7. When the player levels up, increase the player's score by 50 points and log the new score to the console.
8. When the player levels up, increase the player's spell damage by 5 points and log the new spell damage to the console.
9. When the player levels up, increase the player's movement speed by 0.5 points and log the new movement speed to the console.
10. When the player levels up, increase the player's spell cooldown reduction by 0.05 seconds and log the new spell cooldown to the console.

## Phase 5: Item System
1. Create an item entity.
   1. The item should have a position component.
   2. The item should have a type component (health potion or xp potion).
   3. The item should have a value component (20 for health potion, 15 for xp potion).
   4. A player can interact with an item by pressing the E key when they are within a certain distance of the item.
   5. When the player interacts with an item, put it in their inventory, increase its quantity if it exists already, and log a message to the console indicating the item was picked up and the new quantity.
   6. When the player uses a health potion, increase the player's health by the item's value and log the new health to the console. Remove one health potion from the inventory.
   7. When the player uses an xp potion, increase the player's xp by the item's value and log the new xp to the console. Remove one xp potion from the inventory.
   8. If the player's health exceeds 100 points, set it to 100 points and log the new health to the console.
   9. If the player's xp exceeds 100 points, set it to 0 points, increase the player's level by 1, and log a "Level Up" message to the console.

## Phase 6: UI and Feedback
1. Then we'll create a simple UI to display the player's health and score.
   1. The UI should update in real-time as the player's health, xp, and score change.
   2. When the player's health reaches 0, display a "Game Over" message on the screen for a brief period before filling the players health back over time.
   3. When the player destroys an enemy or crate, display a brief message on the screen indicating the points earned.
   4. When the player picks up an item, display a brief message on the screen indicating the item picked up.
   5. When the player casts a spell, display a brief message on the screen indicating the spell cast.
   6. When the player clicks the play button, display a brief message on the screen indicating the game has started.
   7. When the player pauses the game, display a "Game Paused" message on the screen.
   8. When the player resumes the game, remove the "Game Paused" message from the screen.
   9. When the player exits the game, display a "Game Exited" message on the screen.
   10. When the player restarts the game, display a "Game Restarted" message on the screen.
   11. When the player saves the game, display a "Game Saved" message on the screen.
   12. When the player loads a saved game, display a "Game Loaded" message on the screen.
   13. When the player picks up an item, update the inventory UI to show the new item.
   14. When the player casts a spell, update the spell-casting UI to show the spell being cast.
   15. When the player destroys an enemy or crate, update the score UI to show the new score.
   16. When the player takes damage, update the health UI to show the new health.
   17. When the player reaches a new level, display a "Level Up" message on the screen.
   18. When the player reaches a new level, update the level UI to show the new level.
   19. When the player kills an enemy, display a "Enemy Defeated" message on the screen and update their score and xp.
