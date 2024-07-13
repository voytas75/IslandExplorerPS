# Island Explorer PS

## Concept
The game is a text adventure where the player explores a mysterious island. The LLM provides descriptions of the environment, generates events, and responds to player actions. The game involves exploration, solving puzzles, and interacting with various elements.

## Components
1. **Introduction and Setup**: Start the game with an introduction and set up the initial environment.
2. **Player Input**: Accept commands from the player.
3. **LLM Interaction**: Use an LLM to generate responses and descriptions.
4. **Game Logic**: Handle the game state, including player inventory, location, and progress.


## Settings

### Environment 

$script:API_AZURE_OPENAI_APIVERSION = "PSAOAI_API_AZURE_OPENAI_APIVERSION"
$script:API_AZURE_OPENAI_ENDPOINT = "PSAOAI_API_AZURE_OPENAI_ENDPOINT"
$script:API_AZURE_OPENAI_CC_DEPLOYMENT = "PSAOAI_API_AZURE_OPENAI_CC_DEPLOYMENT" # Chat Completion
$script:API_AZURE_OPENAI_KEY = "PSAOAI_API_AZURE_OPENAI_KEY"
$script:API_AZURE_OPENAI_D3_DEPLOYMENT = "PSAOAI_API_AZURE_OPENAI_D3_DEPLOYMENT" # Dall-e 3
$script:PSAOAI_BANNER = "PSAOAI_BANNER"


## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Contributing

We welcome contributions from the community! Feel free to submit pull requests, report issues, or suggest new features to make the framework even more powerful and user-friendly.

**Contact:**
If you have any questions or need assistance, please feel free to reach out to us via [GitHub Issues](https://github.com/voytas75/IslandExplorerPS/issues).

Join us on the journey to make PowerShell scripting a truly awesome experience!
