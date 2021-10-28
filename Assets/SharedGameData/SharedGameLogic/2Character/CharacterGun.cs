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
        private void Awake()
        {
            characterHands = GetComponent<CharacterHands>();
        }
        protected override bool CanShoot()
        {
            if (characterHands.HeldItemType != requestedItem)
            {
                return false;
            }
            return base.CanShoot();
        }

        
    }
}