using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using RotaryHeart.Lib.SerializableDictionary;
using Core.Interractables;

namespace ShipsLogic.Guns
{
    public class AmmoBox : ItemDeposit
    {

        [SerializeField] string requestedItemWhenEmpty = "AB";
        

        public override void ServerEmpty()
        {
            base.ServerEmpty();
            requestedItemType = requestedItemWhenEmpty;

        }


        protected override void ServerFill()
        {
            base.ServerFill();
            itemQuantity = maxQuantity;
            requestedItemType = null;

        }

    }

}


