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


        short normalItemMaxQuantity;
        string normalItemType;

        public override void OnStartServer()
        {
            base.OnStartServer();
            normalItemMaxQuantity = maxQuantity;
            normalItemType = itemType;
        }

        public override void ServerEmpty()
        {
            base.ServerEmpty();
            itemType = "AB";
            maxQuantity = 1;

        }


        protected override void ServerSetFull()
        {
            base.ServerSetFull();
            maxQuantity = normalItemMaxQuantity;
            itemQuantity = maxQuantity;
            itemType = normalItemType;

        }

    }

}


