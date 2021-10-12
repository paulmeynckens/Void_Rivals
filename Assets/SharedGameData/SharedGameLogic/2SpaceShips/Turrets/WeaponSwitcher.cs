using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Core.ServerAuthoritativeActions;
using Core;

namespace  ShipsLogic.Turrets
{
    public class WeaponSwitcher : NetworkBehaviour
    {
        [SerializeField] ServerAuthoritativeGun rightGun = null;
        [SerializeField] ServerAuthoritativeGun leftGun = null;


        #region syncvars + hooks

        [SyncVar(hook = nameof(ClientChangeWeaponsState))] ShipTwinWeaponsState weaponsState = ShipTwinWeaponsState.both;

        void ClientChangeWeaponsState(ShipTwinWeaponsState _old, ShipTwinWeaponsState _new)
        {
            switch (_new)
            {
                case ShipTwinWeaponsState.left:
                    leftGun.enabled = true;
                    rightGun.enabled = false;
                    break;

                case ShipTwinWeaponsState.both:
                    leftGun.enabled = true;
                    rightGun.enabled = true;
                    break;
                case ShipTwinWeaponsState.right:
                    leftGun.enabled = false;
                    rightGun.enabled = true;
                    break;
            }
        }

        #endregion






        void FixedUpdate()
        {
            if (hasAuthority)
            {
                if (Input.GetKey(KeyBindings.Pairs[Actions.left_weapon]))
                {
                    CmdChangeWeaponState(ShipTwinWeaponsState.left);
                }
                if (Input.GetKey(KeyBindings.Pairs[Actions.both_weapons]))
                {
                    CmdChangeWeaponState(ShipTwinWeaponsState.both);
                }
                if (Input.GetKey(KeyBindings.Pairs[Actions.rigth_weapon]))
                {
                    CmdChangeWeaponState(ShipTwinWeaponsState.right);
                }
                
            }
        }

        [Command(channel = Channels.Unreliable)]
        void CmdChangeWeaponState(ShipTwinWeaponsState desiredState)
        {
            weaponsState = desiredState;
        }
    }

    public enum ShipTwinWeaponsState:byte
    {
        left,
        both,
        right
    }
}

