#include "register_types.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/godot.hpp>

#include <godot_cpp/classes/node.hpp>

using namespace godot;


class HelloNixNode : public Node {
    GDCLASS(HelloNixNode, Node)

protected:
    static void _bind_methods();

public:
    String sayhi(int v) {
        if (v == 1) return String("Hi");
        else if (v == 2) return String("Bye");
        return String("Nixed!");
    }

    HelloNixNode();
    ~HelloNixNode();
};


void initialize_hello_nix(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

    ClassDB::register_class<HelloNixNode>();
}

void uninitialize_hello_nix(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }
}

extern "C" {
// Initialization.
GDExtensionBool GDE_EXPORT hello_nix_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
    godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

    init_obj.register_initializer(initialize_hello_nix);
    init_obj.register_terminator(uninitialize_hello_nix);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}
