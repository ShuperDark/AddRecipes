#include "substrate.h"
#include <string>
#include <cstdio>
#include <chrono>
#include <memory>
#include <vector>
#include <mach-o/dyld.h>
#include <stdint.h>
#include <cstdlib>
#include <sys/mman.h>
#include <random>
#include <cstdint>
#include <unordered_map>
#include <map>
#include <functional>
#include <cmath>
#include <chrono>
#include <libkern/OSCacheControl.h>
#include <cstddef>
#include <tuple>
#include <mach/mach.h>
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/nlist.h>
#include <mach-o/reloc.h>

#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

struct TextureUVCoordinateSet;
struct CompoundTag;

struct Item {
	void** vtable; // 0
	uint8_t maxStackSize; // 8
	int idk; // 12
	std::string atlas; // 16
	int frameCount; // 40
	bool animated; // 44
	short itemId; // 46
	std::string name; // 48
	std::string idk3; // 72
	bool isMirrored; // 96
	short maxDamage; // 98
	bool isGlint; // 100
	bool renderAsTool; // 101
	bool stackedByData; // 102
	uint8_t properties; // 103
	int maxUseDuration; // 104
	bool explodeable; // 108
	bool shouldDespawn; // 109
	bool idk4; // 110
	uint8_t useAnimation; // 111
	int creativeCategory; // 112
	float idk5; // 116
	float idk6; // 120
	char buffer[12]; // 124
	TextureUVCoordinateSet* icon; // 136
	char filler[100];
};

struct Block
{
	void** vtable;
	char filler[0x90-8];
	int category;
	char filler2[0x94+0x19+0x90-4];
};

struct ItemInstance {
	uint8_t count;
	uint16_t aux;
	CompoundTag* tag;
	Item* item;
	Block* block;
};

struct Recipes {
	struct Type {
		Item* item;
		Block* block;
		ItemInstance inst;
		char c;
	};
};

ItemInstance*(*ItemInstance$ItemInstance)(ItemInstance*, int, int, int);

void(*Recipes$addShapedRecipe)(Recipes*, ItemInstance const&, std::string const&, std::vector<Recipes::Type> const&);

static void (*_Recipes$init)(Recipes*);
static void Recipes$init(Recipes* res) {
	_Recipes$init(res);

	ItemInstance diamond;
	
	ItemInstance$ItemInstance(&diamond, 264, 1, 0);

	ItemInstance dirt;
	
	ItemInstance$ItemInstance(&dirt, 3, 1, 0);
//土からダイヤモンドをクラフトできるレシピを追加します
	Recipes$addShapedRecipe(res, diamond, "#", {Recipes::Type{NULL, NULL, dirt, '#'}});
}

%ctor {
	ItemInstance$ItemInstance = (ItemInstance*(*)(ItemInstance*, int, int, int))(0x100756c70 + _dyld_get_image_vmaddr_slide(0));

	Recipes$addShapedRecipe = (void(*)(Recipes*, ItemInstance const&, std::string const&, std::vector<Recipes::Type> const&))(0x100781794 + _dyld_get_image_vmaddr_slide(0));

	MSHookFunction((void*)(0x100774f40 + _dyld_get_image_vmaddr_slide(0)), (void*)&Recipes$init, (void**)&_Recipes$init);
}
