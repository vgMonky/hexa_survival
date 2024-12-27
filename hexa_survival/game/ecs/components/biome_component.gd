# In game/ecs/components/biome_component.gd

extends Component
class_name BiomeComponent

var biome_name: String
var color: Color
var raw_resource: Dictionary = {}  # Dictionary with resources and their probabilities

# Initialize the BiomeComponent with name, color, and resources
func _init(b_name: String, col: Color, res: Dictionary):
	self.biome_name = b_name
	self.color = col
	self.raw_resource = res
