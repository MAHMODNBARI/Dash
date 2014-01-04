/**
 * Defines the DGame class, the base class for all game logic.
 */
module core.dgame;
import core.gameobjectcollection;
import components.assets;
import graphics.graphics;
import utility.time, utility.config, utility.output, utility.input;

enum GameState { Menu = 0, Game = 1, Reset = 2, Quit = 3 };

DGame mainGame;

class DGame
{
public:
	GameState currentState;

	/**
	 * Main Game loop.
	 */
	final void run()
	{
		// Init tasks
		//TaskManager.initialize();

        start();

        // Loop until there is a quit message from the window or the user.
        while( currentState != GameState.Quit )
        {
			if( currentState == GameState.Reset )
				reset();

			//////////////////////////////////////////////////////////////////////////
			// Update
			//////////////////////////////////////////////////////////////////////////

			// Platform specific program stuff
			Graphics.window.messageLoop();

			// Update time
			Time.update();

			// Update input
			Input.update();

			// Update physics
			//if( currentState == GameState.Game )
			//	PhysicsController.stepPhysics( Time.deltaTime );

			// Do the updating of the child class.
			onUpdate();

			//////////////////////////////////////////////////////////////////////////
			// Draw
			//////////////////////////////////////////////////////////////////////////

			// Begin drawing
			Graphics.adapter.beginDraw();

			// Draw in child class
			onDraw();

			// End drawing
			Graphics.adapter.endDraw();
        }

        stop();
	}

	//static Camera camera;

protected:
	/**
	 * To be overridden, logic for when the game is being initalized.
	 */
	void onInitialize() { }
	/**
	 * To be overridden, called once per frame during the update cycle.
	 */
	void onUpdate() { }
	/**
	 * To be overridden, called once per frame during the draw cycle.
	 */
	void onDraw() { }
	/**
	 * To be overridden, called when the came is closing.
	 */
	void onShutdown() { }

	//UserInterface ui;

private:
	/**
	 * Function called to initialize controllers.
	 */
	void start()
	{
		currentState = GameState.Menu;
        //camera = null;

		Config.initialize();
		Output.initialize();
		Graphics.initialize();
		Assets.initialize();
		//Physics.initialize();

        //ui = new UserInterface( this );

        onInitialize();
	}

	/**
	 * Function called to shutdown controllers.
	 */
	void stop()
	{
		Assets.shutdown();
		Graphics.shutdown();
	}

	/**
	 * Called when engine is resetting.
	 */
	void reset()
	{
		onShutdown();

		// Stop controllers
		Assets.shutdown();

		// Reinitialize controllers
		Assets.initialize();

		onInitialize();
	}
}

struct Game( T )
{
	static this()
	{
		mainGame = new T;
	}
}
