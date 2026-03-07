package net.brown_bakers.bakers_transfurs;

import net.brown_bakers.bakers_transfurs.init.InitEntities;
import net.brown_bakers.bakers_transfurs.init.InitItems;
import net.brown_bakers.bakers_transfurs.init.InitTransfurs;
import com.mojang.logging.LogUtils;
import net.minecraft.resources.ResourceLocation;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.eventbus.api.IEventBus;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import org.slf4j.Logger;

// The value here should match an entry in the META-INF/mods.toml file
@Mod(BakersTransfurs.MODID)
public class BakersTransfurs
{
    public static final String MODID = "bakers_transfurs";
    private static final Logger LOGGER = LogUtils.getLogger();


    public BakersTransfurs(FMLJavaModLoadingContext context)
    {
        IEventBus modEventBus = context.getModEventBus();

        modEventBus.addListener(this::commonSetup);
        
        // Register ourselves for server and other game events we are interested in
        MinecraftForge.EVENT_BUS.register(this);
        
        InitEntities.ENTITY_REGISTRY.register(modEventBus);
        InitItems.ITEM_REGISTRY.register(modEventBus);
        InitTransfurs.TF_REGISTRY.register(modEventBus);
    }
    
    private void commonSetup(final FMLCommonSetupEvent event)
    {
    
    }
    
    
    public static ResourceLocation modResource(String path) {
        return new ResourceLocation(MODID, path);
    }
}