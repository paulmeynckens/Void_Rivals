using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.ServerAuthoritativeActions;

namespace CharacterLogic
{
    public class CharacterRollbackTarget : RollbackTarget
    {
        [SerializeField] float damageMultiplier = 1;

        public override void ServerDealDamage(GunData gunData, Vector3 hitPosition)
        {
            health.ServerDealDamage((short)(gunData.damage * damageMultiplier), hitPosition);
        }
    }
}
