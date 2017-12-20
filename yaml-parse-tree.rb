# Parses tree with items categorized by parents

require 'yaml'

tree_str =<<EOF
CATEGORY_A
    SUBCATEGORY_A_A
        - ITEM_A_A_1
        - ITEM_A_A_2
    SUBCATEGORY_A_B
        - ITEM_A_B_1
CATEGORY_B
    SUBCATEGORY_A_A
        -ITEM_B_A_1
        -ITEM_B_A_2
    SUBCATEGORY_A_B
        -ITEM_B_B-1
EOF

def traverse_yaml(obj,parent, &blk)
 case obj
 when Hash
   obj.each do |k,v| 
    print (v)
    
    # First level children
    #blk.call(k,parent)
    
    # Pass hash key as parent
    # traverse_yaml(v,k, &blk) 
   end
 when Array
   obj.each {|v| traverse_yaml(v, parent, &blk) }
 else
   blk.call(obj,parent)
 end
end

# traverse_yaml(YAML.load(tree_str), nil) do |node,parent|
#   puts "Creating node '#{node}' with parent '#{ parent || 'nil' }'"
# end

# Simple yaml parsing
# Row for each -'ed yaml item with parents as attributes

yaml_tree = YAML.load(tree_str)

top_level_items = ['CATEGORY_A', 'CATEGORY_B'] # pull from yaml
second_level_items = ['SUBCATEGORY_A_A', 'SUBCATEGORY_A_B'] # Pull from yaml

root.each do |csckey, cschash|
  cschash.each do |dcckey, dcclist|
    dcclist.each do |item|
# HARDCODE
# top_level_items.each do |csc|
#   puts "===" + csc + "==="
#   second_level_items.each do |dcc|
#     yaml_tree[csc][dcc].each do |item|
      puts "STATUS: " + csc + ", CATEGORY: " + dcc
      puts item
    end
  end
end


