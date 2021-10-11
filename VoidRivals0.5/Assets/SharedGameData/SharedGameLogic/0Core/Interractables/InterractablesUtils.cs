using UnityEngine;
using System;

namespace Core.Interractables
{




    public interface ICanGrabItem
    {
        string HeldItemType
        {
            get;
        }

        void ServerGrabItem(string itemType);

        void ServerDropItem();
    }


}