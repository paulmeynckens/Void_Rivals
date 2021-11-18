using UnityEngine;
using System.Collections;
using Core.ServerAuthoritativeActions;
using System;
using Mirror;
using Core;
using Core.Interractables;

namespace CharacterLogic
{
    public class CharacterGun : ServerAuthoritativeGun
    {
        CharacterHands characterHands;
        [SerializeField] string requestedItem = "PL";
        public event Action<short, short> OnChangeQuantity = delegate { };

        [SyncVar(hook = nameof(ClientCorrectMagasineState))] [SerializeField] protected short ammo = 0;
        void ClientCorrectMagasineState(short _old, short _new)
        {
            OnChangeQuantity(_old, _new);
        }

        private void Awake()
        {
            characterHands = GetComponent<CharacterHands>();
        }
        protected override bool CanShoot()
        {
            if(base.CanShoot() && characterHands.HeldItemType == requestedItem && ammo>0)
            {
                return true;
            }

            return false;

        }

        
    }
}