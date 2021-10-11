using UnityEngine;
using RotaryHeart.Lib.SerializableDictionary;
using System.Collections.Generic;
using ShipsLogic.Guns;

namespace Customisation
{
    public interface ICustomisableGunPart
    {
        void SetGun(ShipGunData newGunData);
        void ResetGun();
    }

    public interface ICustomisableModulePart
    {
        void SetModuleShape(ModuleShape newModuleShape);
        void ResetModuleShape();
    }

    public enum GunType : byte
    {
        none,
        Machine_gun,
        Mass_driver,
    }

    [System.Serializable]
    public class GunsDictionnary : SerializableDictionaryBase<GunType, ShipGunData> { }
}