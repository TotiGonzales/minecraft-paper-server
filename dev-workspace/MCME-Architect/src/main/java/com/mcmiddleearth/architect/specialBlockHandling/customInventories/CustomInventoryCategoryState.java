/*
 * Copyright (C) 2016 MCME
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.mcmiddleearth.architect.specialBlockHandling.customInventories;

import java.util.List;
import java.util.Map;

import org.bukkit.entity.Player;
import org.bukkit.inventory.Inventory;
import org.bukkit.inventory.ItemStack;

/**
 *
 * @author Eriol_Eandur
 */
public class CustomInventoryCategoryState extends CustomInventoryState {
    
    private int upperLeftItem;
    
    private String currentSubcategory = "All"; // Default to "All" to show all items

    public CustomInventoryCategoryState(Map<String, CustomInventoryCategory> categories, CustomInventoryCategory withoutCategory,
                                        Inventory inventory, Player player) {
        super(categories, withoutCategory, inventory, player);
        upperLeftItem = 0;
    }

    CustomInventoryCategoryState(CustomInventoryState state) {
        this(state.categories,state.withoutCategory,state.inventory,state.player);
        currentCategory = state.currentCategory;
        leftCategory = state.leftCategory;
        if(state instanceof CustomInventoryCollectionState collectionState) {
            upperLeftItem = collectionState.getReturnUpperLeftItem();
        }
    }
    
    @Override
    public void update()  {
        super.update();
        CustomInventoryCategory category = categories.get(categoryNames[currentCategory]);
        if(category.isVisible(player)) {
            // Add persistent category navigation buttons in first column (slots 9, 18, 27, 36, 45)
            addCategoryNavigationButtons();
            
            // Get items filtered by current subcategory
            List<ItemStack> items = category.usesSubcategories() 
                ? category.getItemsBySubcategory(currentSubcategory) 
                : category.getItems();
            
            int itemsPlaced = 0;
            for (int slotIndex = CustomInventory.CATEGORY_SLOTS + 1; slotIndex < CustomInventory.CATEGORY_SLOTS + CustomInventory.ITEM_SLOTS; slotIndex++) {
                // Skip first column of each row
                if ((slotIndex - CustomInventory.CATEGORY_SLOTS) % 9 == 0) {
                    continue;
                }
                // Skip pageUp slot if needed
                if(slotIndex == CustomInventory.CATEGORY_SLOTS+8 && !isFirstItemVisible()) {
                    continue;
                }
                // Skip pageDown slot if needed
                if(slotIndex == CustomInventory.CATEGORY_SLOTS+CustomInventory.ITEM_SLOTS-1 && !isLastItemVisible()) {
                    continue;
                }
                int itemIdx = upperLeftItem + itemsPlaced;
                if(itemIdx < items.size() && itemsPlaced < visibleItemSlots()) {
                    inventory.setItem(slotIndex, items.get(itemIdx));
                    itemsPlaced++;
                }
            }
            if(!isFirstItemVisible()) {
                inventory.setItem(CustomInventory.CATEGORY_SLOTS+8,
                                  newPagingItem(pagingMaterial,pageUp, "page up"));
            }
            if(!isLastItemVisible()) {
                inventory.setItem(CustomInventory.CATEGORY_SLOTS+CustomInventory.ITEM_SLOTS-1,
                                  newPagingItem(pagingMaterial,pageDown, "page down"));
            }
        }
    }
    
    @Override
    protected void setCategory(int newCategory) {
        // Only reset subcategory if we're actually switching to a different category
        if (currentCategory != newCategory) {
            upperLeftItem = 0;
            currentSubcategory = "All"; // Reset to "All" when switching categories
        }
        super.setCategory(newCategory);
    }
    
    @Override
    public void pageDown() {
        if(!isLastItemVisible()) {
            upperLeftItem += visibleItemSlots();
        }
    }
    
    @Override
    public void pageUp() {
        if(!isFirstItemVisible()) {
            if(isLastItemVisible()) {
                upperLeftItem -=visibleItemSlots()-1;
            } else {
                upperLeftItem -= visibleItemSlots();
            }
            if(upperLeftItem==1) {
                upperLeftItem=0;
            }
            if(upperLeftItem<0) {
                upperLeftItem = 0 ;
            }
        }
    }
    
    @Override
    public boolean isPageUpSlot(int slot) {
        return (slot == CustomInventory.CATEGORY_SLOTS+8 && !isFirstItemVisible());
    }
    
    @Override
    public boolean isPageDownSlot(int slot) {
        return (slot == CustomInventory.CATEGORY_SLOTS + CustomInventory.ITEM_SLOTS - 1
                && !isLastItemVisible());
    }
    
    public boolean isCategoryButtonSlot(int slot) {
        return slot == 9 || slot == 18 || slot == 27 || slot == 36 || slot == 45;
    }
    
    private int visibleItemSlots() {
        // Count actual available slots, skipping first column and paging buttons
        int availableSlots = 0;
        for (int slotIndex = CustomInventory.CATEGORY_SLOTS + 1; slotIndex < CustomInventory.CATEGORY_SLOTS + CustomInventory.ITEM_SLOTS; slotIndex++) {
            // Skip first column of each row (9, 18, 27, 36, 45)
            if ((slotIndex - CustomInventory.CATEGORY_SLOTS) % 9 == 0) {
                continue;
            }
            // Skip pageUp slot if needed
            if(slotIndex == CustomInventory.CATEGORY_SLOTS+8 && !isFirstItemVisible()) {
                continue;
            }
            // Skip pageDown slot if needed
            if(slotIndex == CustomInventory.CATEGORY_SLOTS+CustomInventory.ITEM_SLOTS-1 && !isLastItemVisible()) {
                continue;
            }
            availableSlots++;
        }
        return availableSlots;
    }
    
    private boolean isFirstItemVisible() {
        return upperLeftItem == 0;
    }
    
    private boolean isLastItemVisible() {
        CustomInventoryCategory category = categories.get(categoryNames[currentCategory]);
        // Get the correct item count based on subcategory filtering
        int itemCount = category.usesSubcategories() 
            ? category.getItemsBySubcategory(currentSubcategory).size() 
            : category.size();
        final int USABLE_ITEM_SLOTS = 40;
        if(itemCount <= USABLE_ITEM_SLOTS) {
            return true;
        } else {
            return itemCount <= upperLeftItem + USABLE_ITEM_SLOTS-2;
        }
    }

    @Override
    public boolean usesSubcategories() {return categories.get(categoryNames[currentCategory]).usesSubcategories();}

    protected int getUpperLeftItem() {
        return upperLeftItem;
    }
    
    public String getCurrentSubcategory() {
        return currentSubcategory;
    }
    
    public void setSubcategory(int buttonIndex) {
        CustomInventoryCategory category = categories.get(categoryNames[currentCategory]);
        if (buttonIndex == 0) {
            currentSubcategory = "All";
        } else {
            List<String> subcategoryNames = category.getSubcategoryNames();
            if (subcategoryNames != null && buttonIndex - 1 < subcategoryNames.size()) {
                currentSubcategory = subcategoryNames.get(buttonIndex - 1);
            }
        }
        upperLeftItem = 0; // Reset to first page when switching subcategories
    }
    
    public int getSubcategoryButtonIndex(int slot) {
        int[] buttonSlots = {9, 18, 27, 36, 45};
        for (int i = 0; i < buttonSlots.length; i++) {
            if (buttonSlots[i] == slot) {
                return i;
            }
        }
        return -1;
    }
    
    private void addCategoryNavigationButtons() {
        // Add persistent category navigation buttons in slots 9, 18, 27, 36, 45
        // Each slot gets its own unique custom model data (100-104) for normal state
        // and (105-109) for active/current state
        int[] buttonSlots = {9, 18, 27, 36, 45};
        int[] customModelData = {100, 101, 102, 103, 104};  // Normal state
        int[] customModelDataCurrent = {105, 106, 107, 108, 109};  // Active state (washed out texture)
        
        CustomInventoryCategory category = categories.get(categoryNames[currentCategory]);
        
        // First button is always "All", remaining buttons use configured subcategory names
        List<String> subcategoryNames = category.getSubcategoryNames();
        String[] buttonNames = new String[5];
        buttonNames[0] = "All";
        for (int i = 1; i < 5; i++) {
            if (subcategoryNames != null && i - 1 < subcategoryNames.size()) {
                buttonNames[i] = subcategoryNames.get(i - 1);
            } else {
                buttonNames[i] = "";  // Empty if no subcategory defined
            }
        }
        
        for (int i = 0; i < buttonSlots.length; i++) {
            if (!buttonNames[i].isEmpty()) {
                // Check if this button represents the currently selected subcategory
                boolean isCurrentSubcategory = buttonNames[i].equals(currentSubcategory);
                int cmdValue = isCurrentSubcategory ? customModelDataCurrent[i] : customModelData[i];
                ItemStack button = newPagingItem(pagingMaterial, cmdValue, buttonNames[i]);
                inventory.setItem(buttonSlots[i], button);
            }
        }
    }

}