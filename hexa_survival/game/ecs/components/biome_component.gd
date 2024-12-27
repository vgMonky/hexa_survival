# In game/ecs/components/biome_component.gd

extends Component
class_name BiomeComponent

var biome_name: String
var color: Color
var raw_resource: Dictionary = {}  # Dictionary with resources and their probabilities
var walkable: bool = true  # Default to true, but can be overridden by specific biomes

# Initialize the BiomeComponent with name, color, resources, and walkability
func _init(b_name: String, col: Color, res: Dictionary, is_walkable: bool = true):
	self.biome_name = b_name
	self.color = col
	self.raw_resource = res
	self.walkable = is_walkable
