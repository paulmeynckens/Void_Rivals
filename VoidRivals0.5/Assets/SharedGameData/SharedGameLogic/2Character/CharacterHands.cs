using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using Mirror;

using Core.Interractables;
using Core;

namespace CharacterLogic
{
    public class CharacterHands : NetworkBehaviour, ICanGrabItem
    {

        CharacterGun characterGun;

        [SerializeField] string[] loadout;

        public event Action<string> OnClientChangeItem = delegate { };

        [SyncVar(hook = nameof(ClientGrabItem))] public string heldItemType = "NO";
        void ClientGrabItem(string _old, string _new)
        {
            OnClientChangeItem(_new);

        }


        private void Awake()
        {
            characterGun = GetComponent<CharacterGun>();
        }

        //item switching from loadout
        void FixedUpdate()
        {
            if (hasAuthority)
            {
                if (Input.GetKey(KeyBindings.Pairs[Actions.item_slot1]))
                {
                    CmdSwitchItem(0);
                    return;
                }
                if (Input.GetKey(KeyBindings.Pairs[Actions.item_slot2]))
                {
                    CmdSwitchItem(1);
                    return;
                }
                if (Input.GetKey(KeyBindings.Pairs[Actions.item_slot3]))
                {
                    CmdSwitchItem(2);
                    return;
                }
                if (Input.GetKey(KeyBindings.Pairs[Actions.item_slot4]))
                {
                    CmdSwitchItem(3);
                    return;
                }
            }
        }

        
        
        string ICanGrabItem.HeldItemType => heldItemType;



        #region Server

        public void ServerGrabItem(string itemType)
        {
            heldItemType = itemType;
        }

        public void ServerDropItem()
        {
            heldItemType = "NO";
        }



        #endregion



        #region Commands

        [Command]
        void CmdSwitchItem(byte itemSlot)
        {
            ServerDropItem();
            ServerGrabItem(loadout[itemSlot]);
        }



        #endregion
    }


}
